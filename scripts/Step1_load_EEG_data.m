% ========================================================================
% step1_load_data.m
% Initialize EEGLAB and load raw EEG files
% ========================================================================

function step1_load_data(cfg)
    % Initialize EEGLAB
    init_eeglab(cfg.eeglab_path);

    % Process EEG files
    process_eeg_files(cfg.input_folder, cfg.output_folder, cfg.file_ext);

    disp('Step 1 completed: EEG data loaded and saved in .set format.');
end
