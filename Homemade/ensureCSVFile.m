function filePath = ensureCSVFile(filePath)
    % Check if the file is a valid .csv file
    if ~isCSVFilePath(filePath)
        disp('The specified file does not exist or is not a .csv file.');
        % Open file selection dialog filtered for .csv files
        [file, location] = uigetfile('*.csv', 'Select a CSV file');
        if isequal(file, 0) || isequal(location, 0)
            disp('No file was selected.');
            filePath = '';  % Return empty if no file is selected
        else
            filePath = fullfile(location, file);  % Create the full file path
            disp(['File selected: ', filePath]);
        end
    else
        % disp(['File is valid: ', filePath]);
    end
end

function isCSVFile = isCSVFilePath(filePath)
    % Check if the location is a valid file and ends with '.csv'
    isCSVFile = isfile(filePath) && endsWith(filePath, '.csv', 'IgnoreCase', true);
end