
% Configuration file: define paths and preprocessing parameters


% Paths
cfg.eeglab_path   = '/path/to/eeglab';      % Change this to your EEGLAB installation
cfg.input_folder  = '/path/to/input_data';  % Folder with raw EEG files
cfg.output_folder = '/path/to/output_data'; % Folder to save processed .set files
cfg.file_ext      = '*.vhdr';               % EEG file extension (e.g., .vhdr, .edf)

% Preprocessing parameters
cfg.highpass = 0.1;     % High-pass filter cutoff
cfg.lowpass  = 40;      % Low-pass filter cutoff
cfg.ica_flag = true;    % Run ICA step or not (true/false)

