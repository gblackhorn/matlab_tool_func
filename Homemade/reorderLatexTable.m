function reorderLatexTable(inputFile, outputFile, newHeaderOrder)
    % reorderLatexTable Reorders columns of a LaTeX table based on a new header order.
    % This function reads a LaTeX document, identifies a tabularx table,
    % reorders its columns according to the specified new order, and writes
    % the modified table back into a new LaTeX file.
    %
    % Usage:
    % reorderLatexTable('input.tex', 'output.tex', {'NewCol1', 'NewCol2', ...})
    %
    % Inputs:
    % inputFile - String or character array representing the file name of the input LaTeX file.
    % outputFile - String or character array representing the file name of the output LaTeX file.
    % newHeaderOrder - Cell array of strings representing the new order of the column headers.
    %
    % Example:
    % reorderLatexTable('example.tex', 'modified_example.tex', {'Median', 'Mean', 'Group', 'STD'})

    % Read the content of the .tex file
    fileContent = fileread(inputFile);

    % Locate the tabularx environment
    tableStart = regexp(fileContent, '\\begin{tabularx}', 'once');
    tableEnd = regexp(fileContent, '\\end{tabularx}', 'once') + length('\end{tabularx}') - 1;
    
    % Extract the part before, within, and after the tabular environment
    preTableContent = strtrim(fileContent(1:tableStart-1));
    tableContent = fileContent(tableStart:tableEnd);
    postTableContent = strtrim(fileContent(tableEnd+1:end));

    % Split the table content into lines
    tableLines = strsplit(tableContent, '\n');
    tableLines = tableLines(~cellfun('isempty', tableLines));  % Remove empty entries

    % Find the header line index
    headerIdx = find(~cellfun('isempty', regexp(tableLines, '&')) & ~contains(tableLines, '\hline'), 1);
    headerLine = tableLines{headerIdx};

    % Extract and clean headers
    headers = strsplit(strtrim(headerLine), ' & ');
    headers = regexprep(headers, '\\\\$', '');  % Remove trailing '\\'
    headers = strtrim(headers);

    % Create a mapping of the new header order to current indices
    [~, newOrder] = ismember(newHeaderOrder, headers);
    if any(newOrder == 0)
        error('One or more headers in the new order do not match the existing headers.');
    end

    % Initialize newTableContent with non-data lines before header
    newTableContent = tableLines(1:headerIdx-1);  % Include everything before header, like \hline

    % Reorder headers
    reorderedHeaders = headers(newOrder);
    newTableContent{end+1} = [strjoin(reorderedHeaders, ' & '), ' \\']; % Add reordered header line

    % Process each data line after the header
    for i = headerIdx+1:length(tableLines)-1
        if ~contains(tableLines{i}, '\hline') && ~isempty(tableLines{i})
            newRow = reorderRow(tableLines{i}, newOrder);
            newTableContent{end+1} = newRow;
        else
            newTableContent{end+1} = tableLines{i};  % Add non-data lines such as \hline directly
        end
    end

    % Add the end tabularx line
    newTableContent{end+1} = '\end{tabularx}';

    % Write the modified content back to the file
    fid = fopen(outputFile, 'w');
    fprintf(fid, '%s\n', preTableContent);  % Use fprintf directly to control newlines
    fprintf(fid, '%s\n', newTableContent{:});
    fprintf(fid, '%s', postTableContent);  % Avoid an extra newline after the post content
    fclose(fid);
    disp(['Modified LaTeX table saved to ', outputFile]);
end

function newRow = reorderRow(row, order)
    % reorderRow Reorders columns of a single row in a LaTeX table.
    % This subfunction is called by reorderLatexTable to process each row of data.
    %
    % Inputs:
    % row - String containing the LaTeX formatted row.
    % order - Array of indices indicating the new order of the columns.
    %
    % Outputs:
    % newRow - String containing the reordered LaTeX formatted row.

    % Trim to remove trailing whitespace and new line markers
    row = strtrim(row);

    % Remove '\\' at the end of the row if present
    if endsWith(row, '\\')
        row = row(1:end-2);
    end
    
    % Split the row into individual columns
    rowParts = strsplit(row, ' & ');
    
    % Reorder the columns according to the new order
    reorderedParts = rowParts(order);
    
    % Combine the reordered parts back into a single string, and add '\\' at the end
    newRow = [strjoin(reorderedParts, ' & '), ' \\'];
end
