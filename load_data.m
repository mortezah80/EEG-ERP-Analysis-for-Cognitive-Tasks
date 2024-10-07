% Initialize EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Base directory containing the data
baseDir = 'P3 Raw Data';
baseDir_eeg = 'bin_epoch';

% List all subject folders
n = 15;  % Set the total number of subjects, e.g., 10 subjects (you can modify this to your specific case)
subjects = cell(1, n);  % Initialize a cell array to store subject names




for i = 1:length(subjects)
    subjects{i} = sprintf('sub-%03d', i);  % Format the subject name with leading zeros
    subjectDir = fullfile(baseDir, subjects{i}, 'eeg');
    
    % Load the preprocessed EEG data (.set file)
    eegSetFile = fullfile(baseDir_eeg, sprintf('Preprocess_Epoch_P3_sub-%03d.set', i));
    
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

        % Update EEGLAB GUI
        eeglab redraw;
        
    else
        fprintf('EEG data file not found for %s.\n', subjects{i});
    end
    
    % Pause for user interaction, if necessary
    pause(1);  % Adjust this to give time to review each EEG dataset in the GUI
end
