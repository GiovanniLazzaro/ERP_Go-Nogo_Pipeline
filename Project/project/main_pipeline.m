%%
%%              Main PIPELINE  - ERP Go/No-Go Project
%% _________________________________________________________________
% This script runs the entire EEG preprocessing pipeline.
% It sequentially calls scripts from the scripts folder,
% which in turn use functions from the functions folder.
% 
% Steps:
%   0. Load configuration from config.m (paths, parameters, etc.)
%   1. Initialize EEGLAB, making all its functions available for use
%   2. Load EEG raw data and converts in .set files
%   3. ...
%   4. ...
%
% Note: Users should create their own config.m template based on config.m
%       and adjust paths according to their system.
%___________________________________________________________________

clear; clc; close all;

fprintf('\n===== STARTING ERP GO/NO-GO PIPELINE =====\n');


%%  STEP 0: ____________________________________________
fprintf('\n[Step 0] Loading configuration...\n');
try
    cfg = config();
    disp("Config is ready");
catch ME
    error ('impossible to execute config.m: %s', ME.message);
end

%%  STEP 1: ____________________________________________
global ALLEEG EEG CURRENTSET ALLCOM;
try
    addpath(cfg.eeglab_path); %add eeglab_path
    [ALLEEG,EEG,CURRENTSET,ALLCOM]= init_eeglab();
catch ME
    error (' impossible to start EEGLAB: %s', ME.message);
end
%% _____________________________________________________
%% STEP 2:

fprintf('\n[Step 2] Import EEG raw files and tranform them in .set files')
try
    carico_EEG(cfg.input_folder,cfg.output_folder,cfg.file_ext);
    fprintf('Step 2 completed. \n')
catch ME
    error('error during file loading: %s', ME.message);
end
%______________________________________________________
%% STEP 3:


%%%% add at the end fprintf('\n===== PIPELINE COMPLETED SUCCESSFULLY =====\n'); %%%

