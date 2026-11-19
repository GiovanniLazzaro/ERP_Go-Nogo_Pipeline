%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Behavioural performance of the Go/No-Go task from the EEG markers.
%
% For every raw BrainVision recording in cfg.input_folder this script
% computes hits, omissions, commission errors, correct rejections and
% reaction times from the stimulus/response triggers (S2/S8, S4/S5),
% using the function behav_from_markers.m. EEGLAB is not needed.
%
% Output (in cfg.behav.output_folder):
%   <recording>_behav_trials.csv : one row per trial
%   behavior_summary.csv         : one row per recording
%
% If the file name contains the condition list (cfg.behav.list_regex, e.g.
% "..._condfile_2"), the order of the stimulus markers is also checked
% against task/conditions/CONDITION_<n>.xlsx.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step 0: Load configuration
cfg = config();

out_folder = char(cfg.behav.output_folder);
if ~isfolder(out_folder)
    mkdir(out_folder);
end

files = dir(fullfile(char(cfg.input_folder), char(cfg.file_ext)));
if isempty(files)
    error('No %s files found in %s', cfg.file_ext, cfg.input_folder);
end

%% Step 1: Loop over recordings
summary_all = table();
for i = 1:numel(files)
    vhdr = fullfile(files(i).folder, files(i).name);
    [~, name] = fileparts(vhdr);
    fprintf('\n[Behaviour] %s\n', name);

    % condition list used for this recording (if it is in the file name)
    cond_file = '';
    tok = regexp(name, cfg.behav.list_regex, 'tokens', 'once');
    if ~isempty(tok)
        cond_file = fullfile(char(cfg.project_root), 'task', 'conditions', ...
                             sprintf('CONDITION_%s.xlsx', tok{1}));
        if ~isfile(cond_file)
            warning('Condition list not found: %s (order not checked)', cond_file);
            cond_file = '';
        end
    end

    try
        [trials, s] = behav_from_markers(vhdr, ...
            'codes',           cfg.behav.codes, ...
            'resp_window_ms',  cfg.behav.resp_window_ms, ...
            'min_rt_ms',       cfg.behav.min_rt_ms, ...
            'conditions_file', cond_file);
    catch ME
        fprintf('  ERROR: %s\n', ME.message);
        continue
    end

    writetable(trials, fullfile(out_folder, [name '_behav_trials.csv']));

    fprintf('  Go: %d hit, %d omission | NoGo: %d commission, %d correct rejection\n', ...
            s.n_hit, s.n_omission, s.n_commission, s.n_correct_rejection);
    fprintf('  RT hit: %.0f +/- %.0f ms (median %.0f)\n', s.rt_hit_mean, s.rt_hit_sd, s.rt_hit_median);

    row = struct('recording', name);                          % recording name first
    f = fieldnames(s);
    for j = 1:numel(f)
        row.(f{j}) = s.(f{j});
    end
    summary_all = [summary_all; struct2table(row, 'AsArray', true)]; %#ok<AGROW>
end

%% Step 2: Save the summary of all recordings
writetable(summary_all, fullfile(out_folder, 'behavior_summary.csv'));
fprintf('\nBehavioural summary saved in %s\n', fullfile(out_folder, 'behavior_summary.csv'));
