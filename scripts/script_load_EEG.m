% ========================================================================
% load_eeg.m
% This script initialize EEGLAB . loads raw EEG files and converts them to .set format
% using the function load_EEG.m
% ========================================================================

clearvars; close all; clc;

%% Step 0: Load configuration (if not loaded)

cfg = config(); % load parameters and paths

%% Step 1: initialize EEGLAB

init_eeglab(cfg.eeglab_path);

%% Step 2: Load and convert raw EEG files
fpritf('\n[SCRIPT] Loading raw EEG data and converting to .set format...\n');
load_EEG_files(cfg, '*.vhdr')
disp('Step 2 completed: EEG data loaded and saved in .set format.');
