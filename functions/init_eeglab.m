function [ALLEEG, EEG, CURRENTSET, ALLCOM] = init_eeglab()

% Init_eeglab  initialize EEGLAB enviroment and returns core variables
%
% Description: 
% This function launches EEGLAB, close the GUI 
% and returns the standard EEGLAB variables.
% It checks if EEGLAB is in the matlab path and
% that the function is called without any input arguments.
%
% USAGE: 
%       [ALLEEG, EEG, CURRENTSET, ALLCOM] = init_eeglab();
%
% Inputs: none
%
% Outputs: 
% ALLEEG (struct)  EEGLAB structure array containing all datasets
% EEG    (struct)  The current EEGLAB dataset structure.
% CURRENTSET (integer) Index of the current dataset in ALLEEG
% ALLCOM  (cell array) History of EEGLAB commands. 
% ___________________________________________________________________


   % input check
   if nargin > 0
    error('The init_eeglab() function does not require any arguments');
   end

   % enviroment check: check if eeglab is on path
   if ~exist('eeglab','file')
    error('eeglab command not found. Check that cfg.eeglab_path in config.m is correct, and that the main_pipeline scritp runs addpath().');
   end


   %  Execution 
   fprintf( "Starting EEGLAB...\n")
   [ALLEEG,EEG,CURRENTSET,ALLCOM] = eeglab;


   % close the GUI - 
   pause(0.5)
   close(gcf); % close (get current figure). 
   
   fprintf('eeglab started successfully and GUI closed \n');

end 
