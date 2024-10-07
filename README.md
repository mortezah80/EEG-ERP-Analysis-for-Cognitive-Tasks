Based on the files you uploaded and the contents of your project, here's a well-structured README file for your repository, along with suggestions on where to include images (pictures).

```markdown
# Visual Oddball Task EEG Preprocessing

This repository contains the code and data for preprocessing and analyzing EEG data collected during a visual oddball task. The preprocessing includes artifact removal using Independent Component Analysis (ICA), event-related potential (ERP) analysis focusing on P3 and Error-Related Negativity (ERN) components, and statistical comparisons of ERP waveforms.

## Table of Contents
- [Introduction](#introduction)
- [Preprocessing Steps](#preprocessing-steps)
- [Bad Channel Identification](#bad-channel-identification)
- [Independent Component Analysis (ICA)](#independent-component-analysis-ica)
- [Event List and Epoching](#event-list-and-epoching)
- [ERP Analysis](#erp-analysis)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This project focuses on preprocessing EEG data from a visual oddball task using MATLAB and the EEGLAB toolbox. The primary steps include loading the data, removing artifacts, and performing ERP analysis. The main goal is to study the P3 and ERN components, which reflect cognitive processing of targets and errors, respectively.

## Preprocessing Steps

### 1. Loading the Data
The EEG data is loaded from `.set` files for each subject. Channel locations and event markers are imported, and the data is prepared for further processing.

```matlab
% Initialize EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% Load the EEG data
EEG = pop_loadset('filename', eegSetFile);
```

### 2. Downsampling and Re-referencing
The data is downsampled to 256 Hz, and then re-referenced to the average of P9 and P10 electrodes to reduce noise.

```matlab
% Downsample to 256 Hz
EEG = pop_resample(EEG, 256);

% Re-reference to P9 and P10
EEG = pop_reref(EEG, {'P9', 'P10'});
```

### 3. Artifact Removal
Horizontal and vertical EOG channels are removed to reduce eye movement artifacts, and a high-pass filter of 0.1 Hz is applied.

```matlab
% Remove HEOG and VEOG channels
EEG = pop_select(EEG, 'nochannel', {'HEOG_left', 'HEOG_right', 'VEOG_lower'});

% Apply a high-pass filter
EEG = pop_eegfiltnew(EEG, 0.1, []);
```

## Bad Channel Identification

Bad channels are identified based on noise levels in both time and frequency domains. These channels are removed before further analysis.

### Example: Frequency-domain and time-domain analysis for Subject 1
- **Channel F8** was removed due to high-frequency noise.

### Image Placement: You can include pictures of the frequency and time-domain plots for different subjects, such as Subject 1 (high noise in channel F8) and Subject 9 (noisy channels PO8 and PO3) here.

## Independent Component Analysis (ICA)

ICA is applied to remove eye movement, muscle, and line noise artifacts. The removed components are documented and classified based on their source.

### Example of Artifact Removal:
- **Example 3**: Eye blinking artifact removed.
- **Example 6**: Muscle artifact removed.

### Image Placement: Add images comparing signals before and after ICA, especially for artifacts like eye blinks and muscle movements.

## Event List and Epoching

Event codes are assigned to the EEG data based on the visual oddball task paradigm. Bins are created for target and non-target conditions, and the data is epoched for P3 and ERN analysis.

```matlab
% Assign event codes
EEG = pop_creabasiceventlist(EEG, 'AlphanumericCleaning', 'on');
% Epoch the data
EEG_P3 = pop_epochbin(EEG, [-200.0 800.0], 'pre');
```

### Image Placement: A diagram explaining the event binning process and epoching (e.g., the time window around the stimulus) can be helpful here.

## ERP Analysis

ERP waveforms are computed for different conditions:
- **Correct Target vs Correct Non-Target**
- **Target Incorrect vs Correct Responses**

The P3 component is analyzed in central-parietal electrodes (e.g., Fz, Cz).

### Image Placement: Display ERP waveforms (e.g., P3 analysis for Fz) and heatmaps showing mean amplitude differences across conditions.

## Installation

To use the code in this repository, you'll need MATLAB and the EEGLAB toolbox.

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/visual-oddball-eeg-preprocessing.git
   ```

2. Install EEGLAB:
   - Download EEGLAB from the [official site](https://sccn.ucsd.edu/eeglab/download.php).
   - Add EEGLAB to your MATLAB path.

## Usage

1. Place your EEG `.set` files in the `data` directory.
2. Run the preprocessing pipeline:
   ```matlab
   preprocessing;
   ```
3. After preprocessing, run the ICA and ERP analysis scripts:
   ```matlab
   create_bins_epochs;
   load_data;
   ```

## Contributing

If you'd like to contribute to this project, please fork the repository and submit a pull request. Ensure that your code adheres to the style and documentation conventions used throughout the project.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
```

### Suggested Image Placement
- **Bad Channel Identification**: Include frequency and time-domain plots for bad channels (e.g., F8 in Subject 1, PO8, and PO3 in Subject 9).
- **Independent Component Analysis (ICA)**: Show before and after ICA images to illustrate the removal of artifacts like eye blinks or muscle activity.
- **Event List and Epoching**: Add a timeline or diagram explaining event codes and the epoching process around stimulus or response onset.
- **ERP Waveforms**: Include ERP waveforms for key electrodes (e.g., Fz, Cz) and comparison heatmaps showing differences in P3 amplitude across conditions.

These visual aids will help users understand the preprocessing steps and the results more clearly. Let me know if you need further customization!
