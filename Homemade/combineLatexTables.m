function [combinedTable, varargout] = combineLatexTables(file1, file2, varargin)
    % Read two Latex table files and horizontally concatenate them 

    p = inputParser;
    addParameter(p, 'saveToFile', false, @islogical);  % Option to save the LaTeX text to a file
    addParameter(p, 'combinedFileName', 'ConcatTable.tex', @ischar);  % combinedFileName for the output .tex file
    addParameter(p, 'deleteOriginalFiles', false, @islogical);  % Option to delete original files after saving
    parse(p, varargin{:});
    
    saveToFile = p.Results.saveToFile;
    combinedFileName = p.Results.combinedFileName;
    deleteOriginalFiles = p.Results.deleteOriginalFiles;  % Boolean to control file deletion

    % Read LaTeX tables and captions from the two files
    [table1, caption1, tableFormat1] = readLatexTable(file1);  % hlines1 keeps track of \hline positions
    [table2, caption2, tableFormat2] = readLatexTable(file2);  % We don't care about hlines in tab2
    
    % Extract row names from the first column of both tables
    rowNames1 = table1{:, 1};  % Extract first column from table1
    rowNames2 = table2{:, 1};  % Extract first column from table2

    % Find the common row names
    commonRows = intersect(rowNames1, rowNames2, 'stable');

    % Filter both tables to include only rows with matching titles (based on first column)
    table1Filtered = table1(ismember(rowNames1, commonRows), :);
    table2Filtered = table2(ismember(rowNames2, commonRows), :);
    
    % Remove the first column from table2 to avoid duplication of row names in the final table
    table2Filtered(:, 1) = [];

    % Horizontally concatenate the two filtered tables
    combinedTable = [table1Filtered, table2Filtered];
    
    % Combine captions with Tab1 and Tab2 prefix
    combinedCaption = ['Tab1: ' caption1 ' | Tab2: ' caption2];

    % Combine the table formats using a separate function
    combinedTableFormat = combineTableFormats(tableFormat1, tableFormat2);

    % Create a combine Latex table
    if saveToFile
        try
            latexText = tableToLatex(combinedTable, 'saveToFile', true, 'filename', combinedFileName,...
                'caption', combinedCaption, 'columnAdjust', combinedTableFormat);
            % Check if file should be deleted after successful save
            if deleteOriginalFiles
                delete(file1);
                delete(file2);
                disp(['Deleted original files: ', file1, ' and ', file2]);
            end
        catch ME
            warning('Failed to save or delete original files: %s', ME.message);
        end
    end

    varargout{1} = combinedCaption;
    varargout{2} = combinedTableFormat;

    % % Now add back the \hline positions from tab1
    % insertHLines(combinedTable, hlines1);
end


function combinedTableFormat = combineTableFormats(tableFormat1, tableFormat2)
    % Step to trim tableFormat2 to remove the format corresponding to the first column (row title)
    if ~isempty(tableFormat2)
        % Split the tableFormat by '|' and remove the first column
        formatParts = strsplit(tableFormat2, '|');
        formatParts = formatParts(~cellfun('isempty', formatParts));  % Remove empty parts
        
        if numel(formatParts) > 1
            tableFormat2Trimmed = strjoin(formatParts(2:end), '|');  % Join without the first column format
            tableFormat2Trimmed = ['|' tableFormat2Trimmed '|'];  % Add pipes back
        else
            tableFormat2Trimmed = '';  % If only one column, nothing remains
        end
    else
        tableFormat2Trimmed = '';
    end

    % Combine table formats, ensuring no extra '|' between tableFormat1 and tableFormat2
    if ~isempty(tableFormat2Trimmed)
        combinedTableFormat = [tableFormat1(1:end-1) tableFormat2Trimmed];
    else
        combinedTableFormat = tableFormat1;  % If tableFormat2 is empty, return only tableFormat1
    end
end

