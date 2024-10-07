



% Initialize EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Base directory containing the data
baseDir = 'P3 Raw Data2';

% List all subject folders
n = 15;  % Set the total number of subjects, e.g., 10 subjects (you can modify this to your specific case)
subjects = cell(1, n);  % Initialize a cell array to store subject names

for i = 1:n
    subjects{i} = sprintf('sub-%03d', i);  % Format the subject name with leading zeros (e.g., sub-001, sub-002, etc.)
end


for i = 1:length(subjects)
    subjectDir = fullfile(baseDir, subjects{i}, 'eeg');
    
    % Load the EEG data (.set and .fdt files)
    eegSetFile = fullfile(subjectDir, [subjects{i} '_task-P3_eeg.set']);
    
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
                eventData = tdfread(eventsFile, 'tab');  % Read the .tsv event file
                EEG = pop_importevent(EEG, 'event', eventData, 'fields', {'latency', 'type'}, 'timeunit', 1e-3);
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

        % Step 1: Downsample to 256 Hz
        EEG = pop_resample(EEG, 256);
        fprintf('Data downsampled to 256 Hz for %s.\n', subjects{i});

        % Step 2: Re-reference to average of P9 and P10 electrodes
        if any(strcmp({EEG.chanlocs.labels}, 'P9')) && any(strcmp({EEG.chanlocs.labels}, 'P10'))
            EEG = pop_reref(EEG, {'P9', 'P10'});
            fprintf('Data re-referenced to average of P9 and P10 for %s.\n', subjects{i});
        else
            warning('P9 or P10 electrodes not found for %s, skipping re-referencing.\n', subjects{i});
        end

        % Step 3: Remove HEOG and VEOG channels
        EEG = pop_select(EEG, 'nochannel', {'HEOG_left', 'HEOG_right', 'VEOG_lower'});
        fprintf('HEOG and VEOG channels removed for %s.\n', subjects{i});
        

        % Step 5: Remove DC offset
        EEG = pop_rmbase(EEG, []);
        fprintf('DC offset removed for %s.\n', subjects{i});
        
        % Step 6: Apply a high-pass filter of 0.1 Hz
        EEG = pop_eegfiltnew(EEG, 0.1, []);
        fprintf('High-pass filter (0.1 Hz) applied for %s.\n', subjects{i});
        

       
        

        
        % Save the preprocessed dataset
        outputFile = fullfile(subjectDir, sprintf('Preprocess_P3_%s.set', subjects{i}));
        EEG = pop_saveset(EEG, 'filename', sprintf('Preprocess_P3_%s.set', subjects{i}), 'filepath', subjectDir);
        fprintf('Preprocessed dataset saved for %s.\n', subjects{i});
        
        % Update EEGLAB GUI
        % eeglab redraw;


        % Update EEGLAB GUI
        % eeglab redraw;
        
    else
        fprintf('EEG data file not found for %s.\n', subjects{i});
    end
    
    % Pause for user interaction, if necessary
    pause(1);  % Adjust this to give time to review each EEG dataset in the GUI
end








