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
