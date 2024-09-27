function [header, tabRows, preTabContent, postTabContent] = extractLatexTabContent(content)
    % extractLatexTabContent Extracts the header, table rows, and surrounding content from a LaTeX tabularx environment.
    %
    % This function parses a LaTeX document (or any string containing a LaTeX document),
    % and extracts the header and data rows from the first tabularx environment found,
    % along with the content before and after the table.
    %
    % Usage:
    % [header, tabRows, preTabContent, postTabContent] = extractLatexTabContent(content)
    %
    % Inputs:
    % content - A string containing the LaTeX document to be parsed.
    %
    % Outputs:
    % header - A string containing the LaTeX header row of the table.
    % tabRows - A cell array of strings, each representing a data row in the table.
    % preTabContent - A string containing all content before the tabularx environment.
    % postTabContent - A string containing all content after the tabularx environment.
    %
    % Example:
    % fileContent = fileread('example.tex');  % Read the content of a LaTeX file
    % [header, tabRows, preTabContent, postTabContent] = extractLatexTabContent(fileContent);
    % disp('Header:');
    % disp(header);
    % disp('Table Rows:');
    % disp(tabRows);
    % disp('Content Before Table:');
    % disp(preTabContent);
    % disp('Content After Table:');
    % disp(postTabContent);

    % Locate the tabularx environment
    tableStartIdx = regexp(content, '\\begin{tabularx}', 'once');
    tableEndIdx = regexp(content, '\\end{tabularx}', 'once', 'end');

    % Extract the part before, within, and after the tabular environment
    preTabContent = strtrim(content(1:tableStartIdx-1));
    tabContent = content(tableStartIdx:tableEndIdx);
    postTabContent = strtrim(content(tableEndIdx+1:end));

    % Extract lines and identify the header and data rows
    lines = strsplit(tabContent, '\n');
    headerIdx = find(~cellfun('isempty', regexp(lines, '&')), 1, 'first');  % First line with & is the header
    header = strtrim(lines{headerIdx});

    % Find rows between header and the ending of the table
    rowsStartIdx = headerIdx + 1;
    rowsEndIdx = find(~cellfun('isempty', regexp(lines, '\\\\')), 1, 'last'); % Last line with \\

    % Filter out rows that only contain hline or are empty
    tabRows = lines(rowsStartIdx:rowsEndIdx);
    tabRows = tabRows(~contains(tabRows, '\hline') & cellfun(@(x) ~isempty(strtrim(x)), tabRows)); % Exclude \hline and empty lines
    tabRows = cellfun(@strtrim, tabRows, 'UniformOutput', false); % Trim whitespace from each row
end
