%% How to use - CONFIG FILE - %%
%________________________________________________________________________________
% This file contains personal settings and local paths needed to run
% the project. It does not contain functional code, but defines variables such as:
%
%   eeglab_path  : path to your local EEGLAB installation
%   data_path    : path to your EEG data
%
% Each user should create a local copy of this file (config.m) and
% update the paths according to their system. Do not include sensitive
% information on GitHub. Only a template file (config.m) with
% placeholder or empty values should be uploaded to the public repository.
%_______________________________________________________________________________


function cfg = config()

% CONFIG - Configuration parameters for ERP Go/No-Go pipeline
%
% Output:
%   cfg :  structure with all the analysis parameters
%
% Notes:
%   - You can use confing.m  to set your specific paramters (es. dataset, filter, epochs) 
%   - The main script and the functions call cfg to keep the pipeline organized and reproducible
%
% Author: [YOUR NAME]
% Date: [ TODAY]

    %% --- EEGLAB PATH ---
    cfg.eeglab_path = (".software/eeglab2025.1") % Path to EEGLAB

    %% --- FOLDER PATH ---
    % Base project directory, where EEG files are located.
    cfg.project_root = 'C:\EEG_project';       

    % Input/Output path for each pre-processing stage:
    cfg.raw_folder = fullfile(project_root,'data_raw');                  % Row data folder
    cfg.import_folder  =  fullfile(project_root,'data_imported');        % .set data imported folder
    cfg.filtered_folder =  fullfile(project_root,'data_filtered');       % folder with filtered EEG
    cfg.epoch_folder =  fullfile(project_root,'data_epoched');
    cfg.ica_folder =  fullfile(project_root,'data_ica');
    cfg.clean_folder = fullfile(project_root,'data_clean');

    % Subject info
    cfg.subject_id   = 'sub-01';              % ID subject
    cfg.filename     = 'sub-01_task-gonogo.set'; % file name EEG (EEGLAB .set)

    %% --- Filtri ---
    cfg.filter.low_cutoff  = 0.1;   % Hz - high-pass (rimuove drift lento)
    cfg.filter.high_cutoff = 30;    % Hz - low-pass (taglia rumore muscolare)
    cfg.filter.notch       = 50;    % Hz - notch filter (opzionale, 50 o 60Hz)

    %% --- Epoching ---
    cfg.epoch.event_types = {'Go', 'NoGo'};   % trigger di interesse
    cfg.epoch.time_window = [-0.2 0.8];       % intervallo in secondi (pre e post stimolo)

    %% --- Baseline Correction ---
    cfg.baseline.window = [-0.2 0];           % finestra in secondi (tipicamente pre-stimolo)

    %% --- ERP Analysis ---
    cfg.erp.average_by = 'condition';         % come fare l’average (per condizione)

    %% --- Plot ---
    cfg.plot.channels   = {'Fz','Cz','Pz'};   % canali di interesse
    cfg.plot.time_range = [-0.2 0.8];         % asse x del plot
    cfg.plot.ylim       = [-10 10];           % microvolt, per coerenza dei plot

end

