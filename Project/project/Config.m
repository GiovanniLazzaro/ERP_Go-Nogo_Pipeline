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

    %% --- PATH ---
    cfg.dataset_path = './data/';             % Row data folder
    cfg.output_path  = './results/';          % Results folder
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

