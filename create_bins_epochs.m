% Initialize EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Base directory containing the data
baseDir = 'P3 Raw Data';
baseDir_eeg = 'ICa';
outputDir = 'bin_epoch';  % Output directory for processed datasets

% Create the output directory if it doesn't exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% List all subject folders
n = 15;  % Total number of subjects
subjects = cell(1, n);  % Initialize a cell array to store subject names

for i = 1:length(subjects)
    subjects{i} = sprintf('sub-%03d', i);  % Format the subject name with leading zeros
    subjectDir = fullfile(baseDir, subjects{i}, 'eeg');
    
    % Load the preprocessed EEG data (.set file)
    eegSetFile = fullfile(baseDir_eeg, sprintf('%d.set', i));
    
    if exist(eegSetFile, 'file')
        EEG = pop_loadset('filename', eegSetFile);
        [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);
        fprintf('EEG data for %s loaded successfully.\n', subjects{i});
        
        % Load the channel locations (from the _channels.tsv file)
        channelsFile = fullfile(subjectDir, [subjects{i} '_task-P3_channels.tsv']);
        if exist(channelsFile, 'file')
            EEG = pop_chanedit(EEG, 'load', {channelsFile 'filetype' 'tsv'});
            [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
            fprintf('Channel locations loaded for %s.\n', subjects{i});
        else
            fprintf('Channels file not found for %s.\n', subjects{i});
        end
        
        % Load the electrode locations (from the _electrodes.tsv file)
        electrodesFile = fullfile(subjectDir, [subjects{i} '_task-P3_electrodes.tsv']);
        if exist(electrodesFile, 'file')
            try
                EEG = pop_chanedit(EEG, 'load', {electrodesFile 'filetype' 'tsv'});
                [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
                fprintf('Electrode locations loaded for %s.\n', subjects{i});
            catch
                warning('Electrode file for %s could not be loaded automatically.', subjects{i});
            end
        else
            fprintf('Electrodes file not found for %s.\n', subjects{i});
        end
        
        % Load the events (from the _events.tsv file)
        eventsFile = fullfile(subjectDir, [subjects{i} '_task-P3_events.tsv']);
        if exist(eventsFile, 'file')
            try
                % Import events into EEGLAB
                EEG = pop_importevent(EEG, 'event', eventsFile, 'fields', {'latency', 'type'}, 'skipline', 1, 'timeunit', 1e-3, 'align', 0);
                [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
                fprintf('Events loaded for %s.\n', subjects{i});
            catch
                warning('Events for %s could not be loaded.', subjects{i});
            end
        else
            fprintf('Events file not found for %s.\n', subjects{i});
        end
        
        % Load the coordinate system (optional, not used directly in this script)
        coordSysFile = fullfile(subjectDir, [subjects{i} '_task-P3_coordsystem.json']);
        if exist(coordSysFile, 'file')
            coordSys = jsondecode(fileread(coordSysFile));
            fprintf('Coordinate system information loaded for %s (not used in this script).\n', subjects{i});
        else
            fprintf('Coordinate system file not found for %s.\n', subjects{i});
        end
        
        % Load the EEG metadata (optional, for documentation purposes)
        eegMetaFile = fullfile(subjectDir, [subjects{i} '_task-P3_eeg.json']);
        if exist(eegMetaFile, 'file')
            eegMeta = jsondecode(fileread(eegMetaFile));
            fprintf('EEG metadata loaded for %s (not used in this script).\n', subjects{i});
        else
            fprintf('EEG metadata file not found for %s.\n', subjects{i});
        end

        % **Start of the new processing steps**

        % 1. Assign event codes to the EEG data
        EEG = pop_creabasiceventlist(EEG, 'AlphanumericCleaning', 'on', ...
            'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' });
        [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
        fprintf('Event codes assigned for %s.\n', subjects{i});

        % 2. Create bin descriptor file (assuming it's the same for all subjects)
        % Make sure you have created a bin descriptor file named 'bin_descriptor.txt'
        % Place it in a known directory, e.g., in the same folder as the script
        binDescriptorFile = 'bin_dicriptor.txt';
        if ~exist(binDescriptorFile, 'file')
            error('Bin descriptor file not found. Please create bin_descriptor.txt in the script directory.');
        end

        % Assign bins to the data using the bin descriptor file
        EEG = pop_binlister(EEG, 'BDF', binDescriptorFile, 'IndexEL', 1, ...
            'SendEL2', 'EEG', 'Voutput', 'EEG');
        [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
        fprintf('Bins assigned for %s.\n', subjects{i});

        % 3. Epoch the EEG data for P3 analysis (-200 ms to 800 ms)
        EEG_P3 = pop_epochbin(EEG, [-200.0 800.0], 'pre');  % Baseline correction using pre-stimulus interval
        [ALLEEG, EEG_P3, CURRENTSET] = eeg_store(ALLEEG, EEG_P3, CURRENTSET);
        fprintf('P3 epochs created for %s.\n', subjects{i});

        % 4. Save the epoched datasets
        outputFileName_P3 = sprintf('Preprocess_Epoch_P3_%s.set', subjects{i});
        EEG_P3 = pop_saveset(EEG_P3, 'filename', outputFileName_P3, 'filepath', outputDir);
        fprintf('P3 epoched dataset saved for %s.\n', subjects{i});

        % **End of the new processing steps**

        % Update EEGLAB GUI
        eeglab redraw;

    else
        fprintf('EEG data file not found for %s.\n', subjects{i});
    end

    % Pause for user interaction, if necessary
    pause(1);  % Adjust this to give time to review each EEG dataset in the GUI
end
