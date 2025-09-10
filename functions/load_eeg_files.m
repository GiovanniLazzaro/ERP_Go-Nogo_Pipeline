
% This function loads vhdr EEG files from a specified input folder, converts them to .set format and then save the files
% in output folder

function load_EEG_files(files, output_folder)

    for i = 1:length(files)
    disp(['Data Loading:', files(i).name])
    EEG = pop_loadbv(input_folder, files(i).name); % load .extention files (es .vhdr)

    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', 'import');
    
    % Saving dataset EEG in .set format
    pop_saveset(EEG, 'filename', [files(i).name(1:end-5) '.set'], 'filepath', output_folder)
end