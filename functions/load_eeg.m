% ========================================================================
% load_EEG_files.m

% Load raw EEG files from the raw_folder and save them as .set files 
% in the import_folder. 
%
% Usage:
%   load_EEG_files(raw_folder, import_folder, file_ext)
%
% Inputs:
%   raw_folder  : path to folder containing raw EEG files
%   import_folder : path to folder where converted .set files will be saved
%   file_ext      : file extension to search for (e.g., '*.vhdr' or '*.edf')
%
% Example:
%   load_EEG_files(cfg.raw_folder, cfg.import_folder, '*.vhdr')
%   see config.m file

% Requirements:
%   - EEGLAB must be initialized before running this function
%
% ========================================================================


config; %this loads all variables defined in config.m file, incluin input/output folder path

function load_EEG_files(raw_folder,import_folder,file_ext) %from Raw data folder to output folder. %'*.vhdr'

  %create output folder if it doesn't exist

  if ~exist(output_folder, 'dir') %in data_raw doesn't exist create it. see config.m
    mkdir(output_folder);
    fprintf('Created output folder %\n', import_folder)
  end


  %--- List all files with the specific extension ---

  files = dir(fullfile(raw_folder,file_ext));
  if isempty(files)
      warning('No files found in %s with extension %s', raw_folder, file_ext);
      return;
  end

  %--- Loop for load each raw file and trasform in .set files.

  for i = 1:length(files)
      fprintf('\n[%d/%d] Loading file: %s\n', i, length(files),files(i).name);

      %load raw EEG data( BrainVision format)
      EEG = pop_loadbv(raw_folder, files(i).name);

      % Assign dataset name
      [~,name,~] = fileparts(files(i).name);
      EEG.setname =name;

      %Create a new EEGLAB dataset
      [ALLEEG, EEG, CURRENTSET] = pop_newset([],EEG,1,'setname',name,'gui','off');


      %Save dataset as .set file
      pop_saveset(EEG,'filename',[name '.set'],'filepath',import_folder);
      fprintf('Saved as: %s\n', fullfile(import_folder, [name '.set']));
  end
  
  fprintf('\n ALL FILES SUCCESSFULLY CONVERTED TO .SET FORMAT. \n');
end









