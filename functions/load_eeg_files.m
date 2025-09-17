
% This function loads vhdr EEG files from a specified input folder, converts them to .set format and then save the files
% in output folder

function load_EEG_files(files, output_folder)

    % insert here some checks that stop if the input folder does not exist or if there are no files in the folder

    for i = 1:length(files)
    disp(['Data Loading:', files(i).name])
    EEG = pop_loadbv(input_folder, files(i).name); % load .extention files (es .vhdr)

    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', 'import');
    
    % Saving dataset EEG in .set format
    pop_saveset(EEG, 'filename', [files(i).name(1:end-5) '.set'], 'filepath', output_folder)
end



%%%%%%%%%%%%%%%%%%%


% ========================================================================
% load_eeg_files.m
% Load all EEG files in input_folder and save them as .set in output_folder
% Convert EEG files to .set format
% ========================================================================

function load_EEG_files(input_folder, output_folder, file_ext)
    % Create output folder if it doesn't exist
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    % List files
    files = dir(fullfile(input_folder, file_ext));
    if isempty(files)
        warning('No files found in %s with extension %s', input_folder, file_ext);
        return;
    end

    % Loop through files
    for i = 1:length(files)
        fprintf('Loading: %s\n', files(i).name);

        EEG = pop_loadbv(input_folder, files(i).name);
        [ALLEEG, EEG, CURRENTSET] = pop_newset([], EEG, 1, 'setname', 'import'); 

        % Save as .set
        [~, name, ~] = fileparts(files(i).name);
        pop_saveset(EEG, 'filename', [name '.set'], 'filepath', output_folder);
    end
end
