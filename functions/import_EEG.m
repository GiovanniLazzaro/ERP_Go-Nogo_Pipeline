function import_EEG(input_folder,output_folder,file_ext)

% =========================================================================
% 
% Load BrainVision EEG files (.vhdr) from input_folder and save them as
% .set files in output_folder. 
%
% Usage: 
%       import_EEG(input_folder,output_folder, file_ext)

% Inputs:
%   input_folder  : path to folder containing raw EEG files
%   output_folder : path to folder where converted .set files will be saved
%   file_ext      : file extension to search for (e.g., '*.vhdr' or '*.edf')
%
% Example:
%   import_EEG(cfg.raw_folder, cfg.import_folder, '*.vhdr')
%   
% INPUT and OUTPUT PATH are taken from config.m files (see config.m)
%
% Requirements: 
%   EEGLAB must be initialized before running this function
% 
% =========================================================================


    % Check output folder
    if ~isfolder(output_folder)
        mkdir(output_folder);
    end

    % Looking for EEG raw file .file_ext in the input_folder
    files = dir(fullfile(input_folder, file_ext));
    if isempty(files)
        warning(' Nessun file %s trovato in %s', file_ext, input_folder);
        return;
    end

    % Loop for EEG raw files in the input_folder
    for i = 1:length(files)
        fprintf('\nImporting: %s\n', files(i).name);

        %EEGLAB function to load BrainVision files .vhdr extension
        
        EEG = pop_loadbv(input_folder, files(i).name);
        [~, name_no_ext, ~] = fileparts(files(i).name); 

        EEG.setname  = name_no_ext;
        EEG.filename = char(EEG.setname);
        EEG.filepath = char(output_folder);

        try
            EEG = pop_saveset(EEG, 'filename', EEG.filename, 'filepath', EEG.filepath);
            fprintf('Saved: %s\n', fullfile(EEG.filepath, EEG.filename));
        catch ME
            fprintf('Error while saving file: %s\n', files(i).name);
            disp(ME.message);
        end
    end

    fprintf('\n All EEG files have been loaded and converted in .set files!\n');
end
