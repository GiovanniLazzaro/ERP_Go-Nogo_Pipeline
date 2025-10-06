# ERP_Go-Nogo_Pipeline
---WORK IN PROGRESS--
MATLAB preprocessing scripts for ERP extraction from Go/No-Go task EEG data

## Description

This project defines a preprocessing pipeline for extracting event-related potentials (ERPs) from EEG data collected during a Go/No-Go task.
The Go/No-Go task is a well-established cognitive paradigm in which participants are instructed to respond to certain stimuli ("Go") and withhold responses to others ("No-Go"). It is commonly used to assess action restraint and motor inhibition, making it valuable for studying cognitive control in both healthy individuals and patients with neurodegenerative conditions such as Parkinson’s Disease.
This repository includes MATLAB scripts to:
Preprocess and clean EEG data
Epoch continuous data around stimulus events
Extract ERPs specific to Go and No-Go trials
Visualize Grand Average ERPs
Compute ERP metrics, such as amplitude and latency for key components (e.g., N200, P300)
The goal is to provide a modular and replicable pipeline that facilitates ERP analysis in Go/No-Go studies.
This project may be useful for neuroscientists, psychologists, or anyone with an interest in neurophysiology-related research

## Go/Nogo Visual Task paradigm
The computer that delivered the stimuli was allocated on a desk and participants were seated in a comfortable chair maintaining 
70 cm from the screen. The experiment was designed using the Psychopy software (PsychoPy v2023.2.3). The computer was linked through an USB cable to the hdEEG acquisition system.
The ‘go’ stimulus was presented for 100 ms as a green circle on the center of the screen. Instead, the ‘nogo’ stimulus was presented for 100ms as a red circle on the center of the screen. 
Each stimulus was presented according to a specific proportion (80% “go”-20%”nogo”) for a total of 200 trials.
Participants were instructed to always respond using a keyboard with their dominant hand and pressing the space bar, as soon as possible,
only when the ‘go’ stimulus appeared on the screen. For the ‘nogo’ stimulus, participants were instructed to retain the response and do not press any keys.
Each stimulus was presented in succession with a fixation before (1 sec) and an interstimulus interval (ITI) that ranges between 0.50/0.75/1 sec. Given the regular distance of the stimuli, this range 
was selected to avoid that predictability of the stimulus could affect habituation to novelty 
when pressing the press bar. To collect the participant’s response, each time a stimulus was delivered, a trigger box sent a marker to the hdEEG acquisition system to 
be displayed on the recording screen. In this way it was possible to check, online and offline, the correctness of the participant’s response. The appearance of a “go” and “nogo” 
stimuli on the task’s screen was marked on the hdEEG recording by the triggers S2 and S8, respectively. This allowed accurately indicating the onset of each stimulus. 
Additionally, the triggers named S4 and S5 were added to mark the exact onset of each response. The S4 trigger appeared each time the participant responded correctly by 
pressing the space bar at the “go” stimulus. Conversely, the S5 trigger appeared on the hdEEG trace when the participant erroneously pressed the space bar at the “nogo” stimulus

Fig.1 This figure represents the Go/Nogo Task paradigm. 
<img width="1007" height="639" alt="image" src="https://github.com/user-attachments/assets/7af313c4-6463-4090-a76a-981bbb1f1c9d" />



## Repository structure
Folder description and Script Overview

# EEG Preprocessing Pipeline

This repository contains a modular MATLAB pipeline for EEG preprocessing (from raw data loading to ICA).  
The project is organized into scripts for each processing step and functions for reusable code blocks.  
 

##  File and Folder Description

### `main_pipeline.m`
Main entry point of the project.  
Runs the full preprocessing pipeline step by step, using the configuration and calling scripts/functions.  

### `config.m`
Centralized configuration file.  
Contains paths, file extensions, preprocessing parameters (filters, ICA flag, etc.).  

### `scripts/`
Folder containing **high-level scripts** for each preprocessing step:
- `step1_load_data.m` → loads raw EEG data into MATLAB/EEGLAB  
- `step2_ch_rejection.m` → rejects bad channels or trials  
- `step3_filters.m` → applies preprocessing filters  
- `step4_run_ICA.m` → performs ICA decomposition  

### `functions/`
Folder containing **single reusable functions**.  
Each file corresponds to one function, named consistently:
- `load_data.m` → function to load EEG data  
- `filter_data.m` → function to apply filters  
- `run_ica.m` → function to run ICA  

### Other files
- **README** → project description and usage instructions  
- **LICENSE** → license for project distribution  

---

## Usage -  How to run
instruction how to use these script:  -- work in progress --

1. Clone the repository  
2. Open MATLAB  
3. Edit `config.m` to set your data paths and parameters  
4. Run the full pipeline:  
   ```matlab
   run_pipeline


## Requirements
This script requires MATLAB and the EEGLAB toolbox for EEG data processing
- MATLAB 
- EEGLAB 


##  Output
work in progress

## Notes
-  Original data are not included due to privacy. 
-  An example dummy dataset is included to allow testing of the pipeline.( ? )- work in progress - 

## License
This project contains a MIT licence. Please read LICENCE file.

## Authors
- Giovanni Lazzaro

## Contributing
Pull request benvenute!!! for any problem, please, send an Issue.
