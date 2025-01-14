function latexText = tableToLatex(tbl, varargin)
    % Parse optional inputs
    p = inputParser;
    addParameter(p, 'saveToFile', false, @islogical);  % Option to save the LaTeX text to a file
    addParameter(p, 'filename', 'table_output.tex', @ischar);  % Filename for the output .tex file
    addParameter(p, 'caption', 'Your caption here', @ischar);  % Caption for the LaTeX table
    addParameter(p, 'label', 'tab:tableLabel', @ischar);  % Label for the LaTeX table
    addParameter(p, 'columnAdjust', '', @ischar);  % Optional input for column adjustments
    parse(p, varargin{:});
    
    saveToFile = p.Results.saveToFile;
    filename = p.Results.filename;
    caption = p.Results.caption;
    label = p.Results.label;
    columnAdjust = p.Results.columnAdjust;

    % Extract the folder path
    saveDir = fileparts(filename);

    % Check if the folder exists, and create it if it doesn't
    if ~isfolder(saveDir)
        mkdir(saveDir); % Create the folder path
        fprintf('Created folder: %s\n', saveDir);
    end
    
    % Initialize an empty string to store the LaTeX text
    latexText = '';

    % Add the LaTeX table environment
    latexText = sprintf('%s\\begin{table}[htbp]\n', latexText);
    latexText = sprintf('%s\\caption{%s}\n', latexText, caption);  % Caption at the beginning
    latexText = sprintf('%s\\centering\n', latexText);
    
    % Determine the number of columns and create the tabularx format string
    numColumns = width(tbl);
    
    % Adjust column format based on 'columnAdjust' input
    if isempty(columnAdjust) || length(columnAdjust) ~= numColumns
        colFormat = repmat('X|', 1, numColumns);  % Default to X for all columns
    else
        colFormat = '';
        for i = 1:numColumns
            colFormat = [colFormat, columnAdjust(i), '|']; %#ok<AGROW>
        end
    end
    
    latexText = sprintf('%s\\begin{tabularx}{\\linewidth}{|%s}\n', latexText, colFormat);
    latexText = sprintf('%s\\hline\n', latexText);
    
    % Write the header row
    header = tbl.Properties.VariableNames;
    headerStr = sprintf('%s & ', header{:});
    headerStr = headerStr(1:end-2); % Remove the last '&'
    latexText = sprintf('%s%s \\\\\n', latexText, headerStr);
    latexText = sprintf('%s\\hline\n', latexText);
    
    % Write the data rows
    for i = 1:height(tbl)
        rowStr = '';
        for j = 1:numColumns
            cellValue = tbl{i, j};
            
            if isnumeric(cellValue) || islogical(cellValue)
                cellStr = num2str(cellValue);
            elseif ischar(cellValue)
                % Replace LaTeX special characters with their safe equivalents
                cellStr = escapeLatexCharacters(cellValue);
                cellStr = sprintf('\\texttt{%s}', cellStr);  % Use \texttt for strings
            elseif iscell(cellValue) && ischar(cellValue{1})
                % Replace LaTeX special characters with their safe equivalents
                cellStr = escapeLatexCharacters(cellValue{1});
                cellStr = sprintf('\\texttt{%s}', cellStr);  % Use \texttt for strings
            elseif iscell(cellValue) && isnumeric(cellValue{1})
                cellStr = num2str(cellValue{1});
            elseif iscell(cellValue) && islogical(cellValue{1})
                cellStr = num2str(cellValue{1});
            elseif iscategorical(cellValue)
                % Replace LaTeX special characters with their safe equivalents
                cellStr = escapeLatexCharacters(char(cellValue));
                cellStr = sprintf('\\texttt{%s}', cellStr);  % Use \texttt for categorical values
            else
                error('Unsupported data type in table.');
            end
            
            rowStr = [rowStr, cellStr, ' & ']; %#ok<AGROW>
        end
        rowStr = rowStr(1:end-2); % Remove the last '&'
        latexText = sprintf('%s%s \\\\\n', latexText, rowStr);
    end
    
    % Write the end of the LaTeX table environment
    latexText = sprintf('%s\\hline\n', latexText);
    latexText = sprintf('%s\\end{tabularx}\n', latexText);
    latexText = sprintf('%s\\label{%s}\n', latexText, label);  % Keep label at the end
    latexText = sprintf('%s\\end{table}\n', latexText);

    % Add the FloatBarrier directive to ensure table placement
    % latexText = sprintf('%s%% Force LaTeX to place this table before continuing\n', latexText);
    latexText = sprintf('%s\\FloatBarrier %% Force LaTeX to place this table before continuing\n', latexText);
    
    % Optionally save to a .tex file
    if saveToFile
        % Open the file in write mode ('w') to overwrite existing content
        fid = fopen(filename, 'w');
        if fid == -1
            error('Cannot open file for writing: %s', filename);
        end
        fprintf(fid, '%s', latexText);
        fclose(fid);
        fprintf('LaTeX table saved to %s\n', filename);
    end
end

function safeStr = escapeLatexCharacters(str)
    % Replace LaTeX special characters with their safe equivalents
    
    % Replace braces first to avoid conflicts with \textasciitilde{}
    safeStr = strrep(str, '{', '\{');                  % Left brace
    safeStr = strrep(safeStr, '}', '\}');              % Right brace
    
    % Now replace other LaTeX special characters
    safeStr = strrep(safeStr, '\', '\\');              % Backslash
    safeStr = strrep(safeStr, '_', '\_');              % Underscore
    safeStr = strrep(safeStr, '~', '\textasciitilde{}'); % Tilde
    safeStr = strrep(safeStr, '&', '\&');              % Ampersand
    safeStr = strrep(safeStr, '%', '\%');              % Percent
    safeStr = strrep(safeStr, '$', '\$');              % Dollar sign
    safeStr = strrep(safeStr, '#', '\#');              % Hash
end

