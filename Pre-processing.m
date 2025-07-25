%%%% Save .set files %%%%%%

clear 
close all
clc


% Initialize parameters for EEGLAB 
eeglab_path = 
addpath(genpath(eeglab_path))

% Define raw input folder. % Defining the path where to take EEG file
input_folder = 

% Define raw output folder (raw .set datasets) %return EEG.set file ready to be loaded on EEGLAB
output_folder = 

% Create output folder if it doesnt exist
if ~exist("output_folder", 'dir')
    mkdir(output_folder);
end

% Ottieni tutti i file EEG nella cartella di interesse 'gonogo'
files = dir(fullfile(input_folder, '*.vhdr')); % Specificare l'estensione

% Start EEGLAB
eeglab;

for i = 1:length(files)
    disp(['Caricamento file:', files(i).name])
    EEG = pop_loadbv(input_folder, files(i).name); % load .vhdr files

    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', 'import');
    
    % Salvataggio del dataset EEG in .set format
    pop_saveset(EEG, 'filename', [files(i).name(1:end-5) '.set'], 'filepath', output_folder)
end

%%


clear all 
close all
clc

% Initialize stuff for EEGLAB
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



% current directory: seleziono i file dalla input folder che contengono
% estensione .set 
cd(input_folder)
input_data = dir('*.set');
input_file = {input_data.name};
% Loop over subjects

for i=1:length(input_data)
    current_subj = input_data(i).name;

    %load data
    EEG=pop_loadset(current_subj,input_folder);



%plot EEG per la visual ispection
    pop_eegplot( EEG, 1, 1, 1);

 %rimozione canali EMG non utili
    EEG=pop_select(EEG, 'rmchannel', {'...','...'});
    eeglab redraw; %per aggiornare EEGLAB


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
