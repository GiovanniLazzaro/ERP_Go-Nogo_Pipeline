function import_EEG(input_folder, output_folder, file_ext)

% =========================================================================
% 
% Load BrainVision EEG files (.vhdr) from input_folder and save them as
% .set files in output_folder. 
%
% Usage: 
%       import_EEG_def(input_folder,output_folder, file_ext)

% Inputs:
%   input_folder  : path to folder containing raw EEG files
%   output_folder : path to folder where converted .set files will be saved
%   file_ext      : file extension to search for (e.g., '*.vhdr' or '*.edf')
%
% Example:
%   load_EEG_files(cfg.raw_folder, cfg.import_folder, '*.vhdr')
%   
% INPUT and OUTPUT PATH are taken from config.m files (see config.m)
%
% Requirements: 
%   EEGLAB must be initialized before running this function
% 
% =========================================================================



    %Setting EEGLAB global variables 
    global ALLEEG EEG CURRENTSET;
    if isempty(ALLEEG)
        ALLEEG = [];
    end
    if isempty(CURRENTSET)
        CURRENTSET = 0;
    end

    % Check output folder 
    if ~isfolder(output_folder)
        mkdir(output_folder);
    end

    % Looking for EEG raw file 
    files = dir(fullfile(input_folder), file_ext);
    if isempty(files)
        warning(' No existing files %s have been found in %s', file_ext, input_folder);
        return;
    end

    % Loop for EEG raw files in the input_folder
    for i = 1:length(files)
        fprintf('\nImporting: %s\n', files(i).name);

        try
            % Load Brain Vision files
            EEG = pop_loadbv(char(input_folder), files(i).name);
            [~, name_no_ext, ~] = fileparts(files(i).name); 

            % Add global variables to EEGLAB ( set the 'gui', 'off')
            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, ...
                                                    'setname', name_no_ext, ...
                                                    'gui', 'off');

            % Define filename and path
            EEG.filename = [name_no_ext '.set']; 
            EEG.filepath = char(output_folder);

            % 
            % (optional) Add 'savemode', 'resave' to transcript files without asking.
            EEG = pop_saveset(EEG, 'filename', EEG.filename, ...
                                 'filepath', EEG.filepath, ...
                                 'savemode', 'resave'); 

            fprintf('Saved: %s\n', fullfile(EEG.filepath, EEG.filename));

        catch ME
            fprintf('Error while saving file: %s\n', files(i).name);
            disp(ME.message);
        end
    end

    % Optional: Refresh GUI
    %  eeglab redraw; 
    
    fprintf('\nAll files imported, saved, and added to ALLEEG!\n');
end
