% This script initialize EEGLAB
% Add EEGLAB to path and start it

function init_eeglab(eeglab_path)
    if nargin < 1
        error('EEGLAB path not provided.');
    end

    addpath(genpath(eeglab_path));
    eeglab; % Start EEGLAB
end
