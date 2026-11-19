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
The PsychoPy code to run the task is in the [`task/`](task/) folder (see [`task/README.md`](task/README.md) for instructions).

The computer that delivered the stimuli was placed on a desk and participants were seated in a comfortable chair, 70 cm from the screen.
The experiment was designed with PsychoPy (v2023.2.3). The stimulation computer was connected through a USB cable (serial trigger box) to the hdEEG acquisition system.

The 'go' stimulus was a green circle and the 'nogo' stimulus a red circle, presented at the centre of the screen.
The task consisted of 200 trials (80% 'go', 20% 'nogo': 160 'go' and 40 'nogo') presented in a pseudo-randomised order,
with the first trial always 'go' and no two consecutive 'nogo' trials. A self-paced pause was given after 100 trials (20 'nogo' trials in each half).
Participants were instructed to respond as fast as possible with their dominant hand by pressing the space bar only when the 'go' stimulus appeared,
and to withhold the response for the 'nogo' stimulus.

Each trial started with a blank screen of variable duration (0.5, 0.75 or 1 s, randomly chosen) to reduce the predictability of stimulus onset.
The stimulus then remained on screen for up to 1 s, or until the space bar was pressed (response window: 1 s), and was followed by a 0.5 s blank inter-trial interval.

A trigger was sent to the hdEEG acquisition system at the onset of each stimulus and of each response, so that the correctness of the participant's
response could be checked online and offline. The onset of 'go' and 'nogo' stimuli was marked by the triggers S2 and S8, respectively.
The triggers S4 and S5 marked the onset of each response: S4 when the participant correctly pressed the space bar after a 'go' stimulus,
S5 when the participant erroneously pressed the space bar after a 'nogo' stimulus (commission error).
Omissions ('go' without response) and correct rejections ('nogo' without response) have no response trigger.

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
