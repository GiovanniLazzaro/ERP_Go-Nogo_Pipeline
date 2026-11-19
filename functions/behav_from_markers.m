function [trials, summary] = behav_from_markers(vhdr_file, varargin)
% BEHAV_FROM_MARKERS  Behavioural performance of the Go/No-Go task from the
% EEG markers of a BrainVision recording.
%
% Accuracy and reaction times are computed from the stimulus and response
% triggers (S2/S8 and S4/S5), so they do not depend on the PsychoPy output
% (in the original task version the column key_resp_2.corr is wrong).
% EEGLAB is not required: the .vhdr and .vmrk files are read as text.
%
% USAGE:
%   [trials, summary] = behav_from_markers(vhdr_file)
%   [trials, summary] = behav_from_markers(vhdr_file, 'conditions_file', 'CONDITION_2.xlsx')
%
% INPUT:
%   vhdr_file : BrainVision header file (.vhdr) of the raw (not segmented)
%               recording; the marker file is taken from its MarkerFile entry
%
% OPTIONAL NAME/VALUE PAIRS:
%   'codes'           struct with fields go, nogo, resp_go, resp_nogo
%                     (default: go=2, nogo=8, resp_go=4, resp_nogo=5)
%   'resp_window_ms'  response window of the task (default 1000)
%   'tolerance_ms'    extra time accepted after the window, for the
%                     trigger delay of up to one frame (default 50)
%   'min_rt_ms'       responses faster than this are flagged as
%                     anticipations and excluded from the RT statistics
%                     (default 150)
%   'conditions_file' condition list (.xlsx, column stim_type) used for the
%                     recording; if given, the order of the stimulus markers
%                     is checked against it (default '': no check)
%
% OUTPUT:
%   trials  : table, one row per stimulus marker
%             trial, stim ('go'/'nogo'), stim_sample, resp_code (NaN = none),
%             rt_ms (NaN = none), outcome ('hit', 'omission', 'commission',
%             'correct_rejection'), anticipation (true/false),
%             code_ok (response code matches the stimulus type)
%   summary : struct with counts, rates and RT statistics (see end of file)
%
% Outcomes:
%   Go   + response    -> hit             Go   + no response -> omission
%   NoGo + response    -> commission      NoGo + no response -> correct_rejection
%
% Note: the response trigger is sent on the screen flip after the key press,
% so RTs from markers can be up to one frame (~17 ms at 60 Hz) longer than
% the RTs saved by PsychoPy.
% =========================================================================

    %% Options
    p = inputParser;
    addParameter(p, 'codes', struct('go', 2, 'nogo', 8, 'resp_go', 4, 'resp_nogo', 5));
    addParameter(p, 'resp_window_ms', 1000);
    addParameter(p, 'tolerance_ms', 50);
    addParameter(p, 'min_rt_ms', 150);
    addParameter(p, 'conditions_file', '');
    parse(p, varargin{:});
    o = p.Results;
    c = o.codes;

    %% Header: sampling rate and marker file
    vhdr_file = char(vhdr_file);
    hdr = fileread(vhdr_file);
    si = regexp(hdr, 'SamplingInterval=([\d\.]+)', 'tokens', 'once');
    if isempty(si)
        error('behav_from_markers:noFs', 'SamplingInterval not found in %s', vhdr_file);
    end
    fs = 1e6 / str2double(si{1});                       % Hz (interval is in microseconds)

    mk = regexp(hdr, 'MarkerFile=([^\r\n]+)', 'tokens', 'once');
    if isempty(mk)
        error('behav_from_markers:noVmrk', 'MarkerFile not found in %s', vhdr_file);
    end
    vmrk_file = fullfile(fileparts(vhdr_file), strtrim(mk{1}));
    if contains(hdr, 'SegmentationType=')
        error('behav_from_markers:segmented', ...
              '%s is a segmented file: use the raw (continuous) recording.', vhdr_file);
    end

    %% Markers: "Mk<n>=Stimulus,S  2,<sample>,<size>,<channel>"
    txt = fileread(vmrk_file);
    tok = regexp(txt, 'Mk\d+=Stimulus,S\s*(\d+),(\d+),', 'tokens');
    code = cellfun(@(t) str2double(t{1}), tok);
    samp = cellfun(@(t) str2double(t{2}), tok);
    n_new_segment = numel(regexp(txt, 'Mk\d+=New Segment', 'match'));

    is_stim = ismember(code, [c.go c.nogo]);
    is_resp = ismember(code, [c.resp_go c.resp_nogo]);
    unexpected = code(~is_stim & ~is_resp);

    stim_idx = find(is_stim);
    n = numel(stim_idx);
    if n == 0
        error('behav_from_markers:noStim', 'No stimulus markers found in %s', vmrk_file);
    end

    %% One row per stimulus: first response before the next stimulus
    stim        = cell(n, 1);
    stim_sample = zeros(n, 1);
    resp_code   = nan(n, 1);
    rt_ms       = nan(n, 1);
    outcome     = cell(n, 1);
    code_ok     = true(n, 1);
    n_extra = 0;   % responses after the first one in the same trial
    n_late  = 0;   % responses outside the response window

    max_rt = o.resp_window_ms + o.tolerance_ms;
    for k = 1:n
        i = stim_idx(k);
        is_go = code(i) == c.go;
        if is_go, stim{k} = 'go'; else, stim{k} = 'nogo'; end
        stim_sample(k) = samp(i);

        if k < n, next_i = stim_idx(k + 1); else, next_i = numel(code) + 1; end
        r = find(is_resp((i + 1):(next_i - 1))) + i;    % responses before the next stimulus

        if ~isempty(r)
            rt = (samp(r(1)) - samp(i)) / fs * 1000;
            if rt > max_rt
                n_late = n_late + numel(r);
                r = [];                                   % not a response to this stimulus
            else
                resp_code(k) = code(r(1));
                rt_ms(k)     = rt;
                n_extra      = n_extra + numel(r) - 1;
                code_ok(k)   = (is_go && resp_code(k) == c.resp_go) || ...
                               (~is_go && resp_code(k) == c.resp_nogo);
            end
        end

        if is_go
            if isempty(r), outcome{k} = 'omission';   else, outcome{k} = 'hit';        end
        else
            if isempty(r), outcome{k} = 'correct_rejection'; else, outcome{k} = 'commission'; end
        end
    end
    n_orphan = sum(is_resp(1:stim_idx(1) - 1));          % responses before the first stimulus

    anticipation = rt_ms < o.min_rt_ms;                   % NaN < x is false

    trials = table((1:n)', stim, stim_sample, resp_code, rt_ms, outcome, anticipation, code_ok, ...
        'VariableNames', {'trial', 'stim', 'stim_sample', 'resp_code', 'rt_ms', ...
                          'outcome', 'anticipation', 'code_ok'});

    %% Optional check against the condition list
    list_mismatches = NaN;
    if ~isempty(o.conditions_file)
        L = readtable(char(o.conditions_file));
        expected = lower(strtrim(cellstr(string(L.stim_type))));
        if numel(expected) ~= n
            warning('behav_from_markers:listLength', ...
                    '%d stimulus markers, but %d trials in %s', n, numel(expected), o.conditions_file);
        end
        m = min(n, numel(expected));
        list_mismatches = sum(~strcmp(expected(1:m), stim(1:m))) + abs(numel(expected) - n);
    end

    %% Summary
    is_hit = strcmp(outcome, 'hit');
    is_com = strcmp(outcome, 'commission');
    rt_hit = rt_ms(is_hit & ~anticipation);
    rt_com = rt_ms(is_com & ~anticipation);

    summary = struct();
    summary.n_trials            = n;
    summary.n_go                = sum(strcmp(stim, 'go'));
    summary.n_nogo              = sum(strcmp(stim, 'nogo'));
    summary.n_hit               = sum(is_hit);
    summary.n_omission          = sum(strcmp(outcome, 'omission'));
    summary.n_commission        = sum(is_com);
    summary.n_correct_rejection = sum(strcmp(outcome, 'correct_rejection'));
    summary.hit_rate            = summary.n_hit / summary.n_go;
    summary.commission_rate     = summary.n_commission / summary.n_nogo;
    summary.rt_hit_mean         = mean(rt_hit);
    summary.rt_hit_median       = median(rt_hit);
    summary.rt_hit_sd           = std(rt_hit);
    summary.rt_commission_mean  = mean(rt_com);
    summary.n_anticipation      = sum(anticipation);
    summary.n_code_mismatch     = sum(~code_ok);
    summary.n_extra_responses   = n_extra;
    summary.n_late_responses    = n_late;
    summary.n_orphan_responses  = n_orphan;
    summary.n_unexpected_codes  = numel(unexpected);
    summary.n_new_segment       = n_new_segment;
    summary.list_mismatches     = list_mismatches;
    summary.fs                  = fs;

    %% Warnings for anything that needs a look
    if ~isempty(unexpected)
        warning('behav_from_markers:codes', 'Unexpected marker codes: %s', mat2str(unique(unexpected)));
    end
    if summary.n_code_mismatch > 0 || n_extra > 0 || n_late > 0 || n_orphan > 0
        warning('behav_from_markers:responses', ...
                '%d code mismatches, %d extra, %d late and %d orphan responses', ...
                summary.n_code_mismatch, n_extra, n_late, n_orphan);
    end
    if n_new_segment > 1
        warning('behav_from_markers:segments', ...
                '%d "New Segment" markers: the recording was paused/restarted.', n_new_segment);
    end
    if ~isnan(list_mismatches) && list_mismatches > 0
        warning('behav_from_markers:list', ...
                'Stimulus order differs from %s in %d trials.', o.conditions_file, list_mismatches);
    end
end
