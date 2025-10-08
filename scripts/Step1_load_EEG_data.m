% ========================================================================
% load_eeg.m
% This script initialize EEGLAB . loads raw EEG files and converts them to .set format
% using the function load_EEG.m
% ========================================================================

clarvars - except cfg; %clear variables except config.
%% Step 0: Load configuration (if not loaded)

if ~exist('cfg' ,'var')
   cfg = config();
end

%% Step 1: initialize EEGLAB

init_eeglab(cfg.eeglab_path);

%% Step 2: Load and convert raw EEG files
fpritf('\n[SCRIPT] Loading raw EEG data and converting to .set format...\n');
load_eeg(cfg, '*.vhdr')
disp('Step 2 completed: EEG data loaded and saved in .set format.');
