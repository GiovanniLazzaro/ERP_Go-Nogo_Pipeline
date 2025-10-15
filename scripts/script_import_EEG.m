%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This scritp allow to import EEG raw files from the input_folder 
% and save the as .set file in the output_folderù
%
% EEGLAB must be launched before running this script.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg=config()
%%  Step 1: 
fprintf('\n[Step 1] Initializing EEGLAB...\n');
init_eeglab(cfg.eeglab_path);

%% Step 2: 
fprintf('\n[Step 2] Import EEG raw files and tranform them in .set files')
cfg=config();
import_EEG(cfg.input_folder,cfg.output_folder,cfg.file_ext);
fprintf('\n All EEG files have been loaded and converted in .set files!\n');


