%% ==========================
%% Main Script - Initialization
%% ==========================
% This section sets up the project environment by loading user-specific
% configuration variables and initializing EEGLAB. 
% 
% Steps:
%   1. Load configuration from config.m (paths, parameters, etc.)
%   2. Initialize EEGLAB, making all its functions available for use
%
% Note: Users should create their own config.m based on config_template.m
%       and adjust paths according to their system.

%% Load configuration
config;  % this loads all variables defined in your config.m file

%% Initialize EEGLAB
init_eeglab(eeglab_path);  % uses the variable defined in config

