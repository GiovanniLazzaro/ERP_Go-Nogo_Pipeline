% PSEUDORANDOMCONDITION  Generate a pseudo-randomised Go/No-Go condition file
% for gonogo_task.py (MATLAB alternative to generate_conditions.py).
%
% Constraints:
%   - exact proportion of Go / NoGo trials (default 80% / 20%)
%   - the first trial is always Go
%   - no two NoGo trials in a row
% Each NoGo is placed right after a distinct Go trial, so the constraints hold
% by construction (no post-hoc replacement, which would change the ratio).
%
% Output: CONDITION_<list_id>.xlsx with columns stim_type, Color, corrAnswer.

%% Parameters
tot_condition        = 200;   % total number of trials
desired_percentage_go = 0.8;  % proportion of Go trials
list_id              = 1;     % output file: CONDITION_<list_id>.xlsx
seed                 = [];    % set e.g. seed = 1 for a reproducible list

if ~isempty(seed), rng(seed); end

%% Build the sequence
num_go   = round(tot_condition * desired_percentage_go);
num_nogo = tot_condition - num_go;
assert(num_nogo <= num_go, 'Cannot avoid consecutive NoGo trials with p_go < 0.5');

followed_by_nogo = false(1, num_go);
followed_by_nogo(randperm(num_go, num_nogo)) = true;

stim_type = cell(tot_condition, 1);
k = 0;
for i = 1:num_go
    k = k + 1; stim_type{k} = 'go';
    if followed_by_nogo(i)
        k = k + 1; stim_type{k} = 'nogo';
    end
end

%% Checks
is_nogo = strcmp(stim_type, 'nogo');
assert(sum(~is_nogo) == num_go && sum(is_nogo) == num_nogo);
assert(~is_nogo(1));
assert(~any(is_nogo(1:end-1) & is_nogo(2:end)));

%% Export
Color = repmat({'green'}, tot_condition, 1);  Color(is_nogo) = {'red'};
corrAnswer = repmat({'space'}, tot_condition, 1);  corrAnswer(is_nogo) = {'none'};

out_file = sprintf('CONDITION_%d.xlsx', list_id);
writetable(table(stim_type, Color, corrAnswer), out_file);
fprintf('Saved %s (%d Go, %d NoGo)\n', out_file, num_go, num_nogo);
