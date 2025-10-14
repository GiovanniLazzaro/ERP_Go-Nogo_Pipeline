function init_eeglab(eeglab_path)


%%% This script initialize and launch EEGLAB
% 
% USAGE: 
%       init_eeglab(eeglab_path)
%
% INPUT:
%        eeglab_path: full path to your EEGLAB installation (see config. file)
%
% Description: 
%             Add EEGLAB to path and start it with GUI
%             Check if EEGLAB is alrady on the matlab path




%input check

if nargin <1 %check n.input arguments
   error ("EEGLAB path not provided");
end

if ~isfolder(eeglab_path)
   error("the provided EEGLAB path does not exist:\n%s", eeglab_path);
end

%check if EEGLAB is already on path

if exist ("eeglab","file")
   fprintf("adding EEGLAB to MATLAB path. \n")
else
   fprintf("adding EEGLAB to MATLAB path \n")
   addpath(genpath(eeglab_path));
end

% LAUNCH EEGLAB
fprintf("Launching EEGLAB...\n");
eeglab; % Start EEGLAB open GUI

end
