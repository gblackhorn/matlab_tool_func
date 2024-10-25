function [tbl, caption, tableFormat] = readLatexTable(filename)
    % Read LaTeX table from the given file and extract table content, caption, and table format.

    % Step 1: Read the LaTeX file content as a string
    data = fileread(filename);

    % Step 2: Extract the caption using a regex pattern for \caption{}
    captionPattern = '\\caption{(.*?)}';
    captionMatch = regexp(data, captionPattern, 'tokens', 'once');
    caption = '';  % Default empty caption
    if ~isempty(captionMatch)
        caption = captionMatch{1};
    end

    % Step 3: Extract the table format (e.g., |X|X|X|X|X|) from \begin{tabularx}
    formatPattern = '\\begin{tabularx}{[^}]*}{(.*?)}';
    formatMatch = regexp(data, formatPattern, 'tokens', 'once');
    tableFormat = '';
    if ~isempty(formatMatch)
        tableFormat = strtrim(formatMatch{1});
    end

    % Step 4: Construct the rowPattern based on the number of columns from tableFormat
    numColumns = length(strfind(tableFormat, 'X')) + length(strfind(tableFormat, 'c'));
    rowPattern = repmat('([^\n]*?) & ', 1, numColumns - 1);
    rowPattern = [rowPattern, '([^\n]*?)\\\\'];  % Match row patterns with dynamic column count

    % Step 5: Extract rows using the dynamically constructed rowPattern
    contentMatch = regexp(data, rowPattern, 'tokens');

    % Step 6: Construct the table from the matched content
    if ~isempty(contentMatch)
        % First row as column headers
        columnTitles = strtrim(contentMatch{1});
        
        % Process rows: Detect numbers vs. text, and clean LaTeX commands from text
        rowData = cellfun(@(x) processLatexRow(x), contentMatch(2:end), 'UniformOutput', false);
        
        % Create table from data and use first row as column headers
        tbl = cell2table(vertcat(rowData{:}), 'VariableNames', columnTitles);
    else
        tbl = table();  % Return empty table if no content found
    end
end

% Helper function: Detect numeric vs. text data, and clean LaTeX formatting from text
function processedRow = processLatexRow(rowData)
    processedRow = cell(size(rowData));  % Initialize processed row
    for i = 1:length(rowData)
        cellContent = strtrim(rowData{i});
        
        % Check if the cell content is numeric
        numericValue = str2double(cellContent);
        if isnan(numericValue)
            % Clean LaTeX commands for text content (e.g., \texttt{}, \textbf{})
            processedRow{i} = cleanLatexString(cellContent);
        else
            processedRow{i} = numericValue;  % Keep numeric content
        end
    end
end

% Clean LaTeX commands (e.g., \texttt{}) and remove LaTeX braces
function cleanStr = cleanLatexString(str)
    % Remove LaTeX formatting commands, keeping the raw text
    cleanStr = regexprep(str, '\\texttt{(.*?)}', '$1');  % Remove \texttt
    cleanStr = regexprep(cleanStr, '\\textbf{(.*?)}', '$1');  % Remove \textbf
    cleanStr = regexprep(cleanStr, '\\textit{(.*?)}', '$1');  % Remove \textit
    cleanStr = regexprep(cleanStr, '[{}]', '');  % Remove braces
end



% function [tbl, caption, tableFormat] = readLatexTable(filename)
%     % Read LaTeX table from the given file and extract table content, caption, and table format.

%     % Step 1: Read the LaTeX file content as a string
%     data = fileread(filename);

%     % Step 2: Extract the caption using a regex pattern for \caption{}
%     captionPattern = '\\caption{(.*?)}';
%     captionMatch = regexp(data, captionPattern, 'tokens', 'once');
%     caption = '';  % Default empty caption
%     if ~isempty(captionMatch)
%         caption = captionMatch{1};
%     end

%     % Step 3: Extract the table format (e.g., |X|X|X|X|X|) from \begin{tabularx}
%     formatPattern = '\\begin{tabularx}{[^}]*}{(.*?)}';
%     formatMatch = regexp(data, formatPattern, 'tokens', 'once');
%     tableFormat = '';
%     if ~isempty(formatMatch)
%         tableFormat = strtrim(formatMatch{1});
%     end

%     % Step 4: Extract rows with pattern "x & x & x \\"
%     rowPattern = '([^\n]*?) & ([^\n]*?) & ([^\n]*?) & ([^\n]*?) & ([^\n]*?)\\\\';  % Match row patterns
%     contentMatch = regexp(data, rowPattern, 'tokens');

%     % Step 5: Construct the table from the matched content
%     if ~isempty(contentMatch)
%         % First row as column headers
%         columnTitles = strtrim(contentMatch{1});
        
%         % Process rows: Detect numbers vs. text, and clean LaTeX commands from text
%         rowData = cellfun(@(x) processLatexRow(x), contentMatch(2:end), 'UniformOutput', false);
        
%         % Create table from data and use first row as column headers
%         tbl = cell2table(vertcat(rowData{:}), 'VariableNames', columnTitles);
%     else
%         tbl = table();  % Return empty table if no content found
%     end
% end

% % Helper function: Detect numeric vs. text data, and clean LaTeX formatting from text
% function processedRow = processLatexRow(rowData)
%     processedRow = cell(size(rowData));  % Initialize processed row
%     for i = 1:length(rowData)
%         cellContent = strtrim(rowData{i});
        
%         % Check if the cell content is numeric
%         numericValue = str2double(cellContent);
%         if isnan(numericValue)
%             % Clean LaTeX commands for text content (e.g., \texttt{}, \textbf{})
%             processedRow{i} = cleanLatexString(cellContent);
%         else
%             processedRow{i} = numericValue;  % Keep numeric content
%         end
%     end
% end

% % Clean LaTeX commands (e.g., \texttt{}) and remove LaTeX braces
% function cleanStr = cleanLatexString(str)
%     % Remove LaTeX formatting commands, keeping the raw text
%     cleanStr = regexprep(str, '\\texttt{(.*?)}', '$1');  % Remove \texttt
%     cleanStr = regexprep(cleanStr, '\\textbf{(.*?)}', '$1');  % Remove \textbf
%     cleanStr = regexprep(cleanStr, '\\textit{(.*?)}', '$1');  % Remove \textit
%     cleanStr = regexprep(cleanStr, '[{}]', '');  % Remove braces
% end
