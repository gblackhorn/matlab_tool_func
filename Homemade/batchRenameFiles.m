function batchRenameFiles(folderPath, originalChars, newChars)
    % Check if the folder exists
    if ~isfolder(folderPath)
        error('The specified folder does not exist: %s', folderPath);
    end
    
    % Get a list of all files in the folder
    files = dir(fullfile(folderPath, '*'));
    
    % Initialize counters
    modifiedCount = 0;
    successCount = 0;
    
    % Iterate over each file
    for i = 1:length(files)
        % Skip directories
        if files(i).isdir
            continue;
        end
        
        % Get the original file name
        oldName = files(i).name;
        
        % Check if the original characters are in the file name
        if contains(oldName, originalChars)
            modifiedCount = modifiedCount + 1; % Count this file as needing modification
            
            % Create the new file name by replacing the original characters with the new ones
            newName = strrep(oldName, originalChars, newChars);
            
            % Full paths for renaming
            oldFullPath = fullfile(folderPath, oldName);
            newFullPath = fullfile(folderPath, newName);
            
            % Attempt to rename the file
            try
                movefile(oldFullPath, newFullPath);
                fprintf('Renamed: %s -> %s\n', oldName, newName);
                successCount = successCount + 1; % Count as successfully renamed
            catch ME
                fprintf('Failed to rename: %s -> %s. Error: %s\n', oldName, newName, ME.message);
            end
        end
    end
    
    % Report the results
    fprintf('Total files containing "%s": %d\n', originalChars, modifiedCount);
    fprintf('Total successfully renamed files: %d\n', successCount);
end
