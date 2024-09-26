function statsTable = summarizeStructStats(dataStruct)
    % This function takes a structure with numeric fields and outputs a table summarizing
    % the mean, median, standard deviation (STD), and standard error of the mean (SEM)
    % for each field.

    % Initialize cell arrays for the table data
    fieldNames = fieldnames(dataStruct);
    numFields = length(fieldNames);
    summaryData = cell(numFields, 5);  % 5 columns: Group, Mean, Median, STD, SEM
    
    % Loop through each field and calculate the statistics
    for i = 1:numFields
        fieldName = fieldNames{i};
        data = dataStruct.(fieldName);
        
        % Check if the field contains numeric data
        if isnumeric(data)
            meanVal = mean(data);
            medianVal = median(data);
            stdVal = std(data);
            semVal = stdVal / sqrt(length(data));  % Standard error of the mean (SEM)
            
            % Store the results in the summaryData array
            summaryData{i, 1} = fieldName;  % Group (field name)
            summaryData{i, 2} = meanVal;    % Mean
            summaryData{i, 3} = medianVal;  % Median
            summaryData{i, 4} = stdVal;     % Standard deviation (STD)
            summaryData{i, 5} = semVal;     % Standard error of the mean (SEM)
        else
            % If the field is not numeric, skip it
            warning('Field %s is not numeric and will be skipped.', fieldName);
        end
    end
    
    % Convert the summaryData cell array to a table
    statsTable = cell2table(summaryData, 'VariableNames', {'Group', 'Mean', 'Median', 'STD', 'SEM'});
end


