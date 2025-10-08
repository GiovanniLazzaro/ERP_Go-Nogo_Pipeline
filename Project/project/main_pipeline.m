%% ==========================
%% Main PIPELINE  - ERP Go/No-Go Project
%% ==========================
% This script runs the entire EEG preprocessing pipeline.
% It sequentially calls scripts from the scripts folder,
% which in turn use functions from the functions folder.
% 
% Steps:
%   0. Load configuration from config.m (paths, parameters, etc.)
%   1. Initialize EEGLAB, making all its functions available for use
%   2. Load EEG raw data and converts in .set files
%
% Note: Users should create their own config.m template based on config.m
%       and adjust paths according to their system.
%=============================

clear; clc; close all;
fprintf('\n===== STARTING ERP GO/NO-GO PIPELINE =====\n');

%%  Step 0: 
fprintf('\n[Step 0] Loading configuration...\n');
cfg = config();

%%  Step 1: 
fprintf('\n[Step 1] Initializing EEGLAB...\n');
init_eeglab(eeglab_path);

%% Step 2: 
fprintf('\n[Step 2] Importing raw EEG files...\n');
run('script/scritp_load_eeg.m');

%% Step 3:




%%%% add at the end fprintf('\n===== PIPELINE COMPLETED SUCCESSFULLY =====\n'); %%%

