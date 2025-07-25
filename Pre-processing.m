%%%% Save .set files %%%%%%

clear 
close all
clc


% Initialize parameters for EEGLAB 
eeglab_path = %add here EEGLAB software path
addpath(genpath(eeglab_path))

% Define raw input folder. 
input_folder = % Defining the path where to take EEG file

% Define raw output folder (raw .set datasets) %return EEG.set file ready to be loaded on EEGLAB
output_folder = %defining the output folder that will collect EEG.set data

% Create output folder if it doesnt exist
if ~exist("output_folder", 'dir')
    mkdir(output_folder);
end

% Load all EEG files from the imput folder 
files = dir(fullfile(input_folder, '*.vhdr')); % .vhdr is an example. Here add your EEG file extention

% Start EEGLAB
eeglab;       %this command starts EEGLAB. Remember to open MATLAB and select the EEGLAB path

for i = 1:length(files)
    disp(['Data Loading:', files(i).name])
    EEG = pop_loadbv(input_folder, files(i).name); % load .extention files

    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', 'import');
    
    % Saving dataset EEG in .set format
    pop_saveset(EEG, 'filename', [files(i).name(1:end-5) '.set'], 'filepath', output_folder)
end

%%


clear all 
close all
clc

% Initialize path for EEGLAB
eeglab_path = 
addpath(genpath(eeglab_path))
eeglab


% Define input folder.set
input_folder = 

% Define output folder pre-ICA datasets .)
output_folder = 

% Create output  if it doesnt exist
if ~exist("output_folder", 'dir')
    mkdir(output_folder);
end



% current directory (cd) select files from input folder containing .set extention 
cd(input_folder)
input_data = dir('*.set');
input_file = {input_data.name};
% Loop over subjects

for i=1:length(input_data)
    current_subj = input_data(i).name;

    %load data
    EEG=pop_loadset(current_subj,input_folder);



%plot EEG for perform visual ispection
    pop_eegplot( EEG, 1, 1, 1);

 %remove bad channels
    EEG=pop_select(EEG, 'rmchannel', {'...','...'}); %here add the name of the channels to be deleted
    eeglab redraw; % refresh EEGLAB


%PAUSA PER IL CONTROLLO MANUALE DATI GREZZI:
    disp('step 1: ispezione e rimuovi manualmente artefatti tramite GUI')
    uiwait(msgbox('ispeziona dati e fai rejection manuale. premi ok per continuare','Pause'));


    %High pass filter
    EEG=pop_eegfiltnew(EEG,'locutoff',0.1);

    %Low pass filter
    EEG=pop_eegfiltnew(EEG,'hicutoff',30);

    %Resample
    EEG=pop_resample(EEG,250);

    EEG=pop_saveset(EEG, ...
        'filename', [current_subj(1:end-4) '_preICA.set'], ...
        'filepath',output_folder);
end
