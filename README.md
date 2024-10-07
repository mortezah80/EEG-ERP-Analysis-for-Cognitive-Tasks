Here is the entire conversation response written in Markdown, including all explanations, instructions, and the content for your `README.md` file. Everything is now properly formatted for Markdown:

markdown
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

### Image Placement: Frequency and Time-domain Plots
You can include pictures of the frequency and time-domain plots for different subjects, such as Subject 1 (high noise in channel F8) and Subject 9 (noisy channels PO8 and PO3) here.

![Subject 1 Frequency Domain](images/s1-fr.png)
*Figure 1: Frequency-domain plot for Subject 1 showing high noise in channel F8.*

![Subject 9 Time Domain](images/s9-td.png)
*Figure 2: Time-domain plot for Subject 9 showing noise in channels PO8 and PO3.*

### Independent Component Analysis (ICA) and Artifact Removal

In this project, Independent Component Analysis (ICA) was used to identify and remove artifacts such as eye blinks, muscle movements, line noise, and other non-brain activity. Below are examples of artifacts identified and removed using ICA.

#### Example 1: Eye Blink Artifact
Eye blink artifacts are common and create large deflections, especially over the frontal electrodes. ICA helped identify the component responsible for these deflections, which was then removed.

![Eye Blink ICA](images/ica_eye_blink.png)
*Figure 1: Scalp map and frequency/time-domain plots showing the eye blink artifact.*

#### Example 2: Muscle Artifact
Muscle artifacts, typically appearing as high-frequency noise, were identified and removed using ICA. These components were classified as non-brain sources based on their high-frequency signatures and scalp distribution.

![Muscle Artifact ICA](images/ica_muscle.png)
*Figure 2: Scalp map and frequency/time-domain plots showing muscle artifact.*

#### Example 3: Line Noise Artifact
Line noise at 60 Hz can contaminate EEG signals. ICA was used to identify and remove this noise.

![Line Noise ICA](images/ica_line_noise.png)
*Figure 3: Scalp map and frequency/time-domain plots showing line noise at 60 Hz.*

#### Example 4: Peak at 23 Hz (Not Typical 1/f Pattern)
An atypical peak at approximately 23 Hz was identified in the data, which is inconsistent with brain activity. ICA was used to remove this component.

![Peak at 23 Hz ICA](images/ica_23hz.png)
*Figure 4: Scalp map and frequency/time-domain plots showing the atypical peak at 23 Hz.*

#### Example 5: Eye Movement Artifact
Eye movement artifacts typically show up as bilateral activity in the frontal electrodes. The rise and fall in the signal correspond to eye movements, which were identified and removed using ICA.

![Eye Movement ICA](images/ica_eye_movement.png)
*Figure 5: Scalp map and frequency/time-domain plots showing the eye movement artifact.*

#### Example 6: Rhythmic Artifact
Rhythmic artifacts, typically non-brain-related oscillations, were identified in the data. These were removed as they did not match expected brain activity patterns.

![Rhythmic Artifact ICA](images/ica_rhythmic.png)
*Figure 6: Scalp map and frequency/time-domain plots showing the rhythmic artifact.*



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

### Steps to Follow:
1. **Copy the entire content** above.
2. **Create a `README.md` file** in the root directory of your GitHub repository.
3. **Paste the copied content** into the `README.md` file.
4. **Save and commit** the file to your GitHub repository.

This will create a well-structured README file for your project in Markdown, which will display correctly on GitHub.

Let me know if you need any additional help!
