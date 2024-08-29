function combinedTable = combineLatexFiles(table1, table2, varargin)
    % Combine two LaTeX or text files (table1 and table2) into a single file.
    % The function adds labels as LaTeX comments above each file's content to distinguish them.

    % Inputs:
        % table1 (required): The file path of the first LaTeX or text file.
        % table2 (required): The file path of the second LaTeX or text file.
        % savePath (optional): The file path where the combined file will be saved.
        %                      If not provided, the combined content will not be saved.
        % label1 (optional): The label (LaTeX comment) for the first file. Defaults to 'Table 1'.
        % label2 (optional): The label (LaTeX comment) for the second file. Defaults to 'Table 2'.
        % ext (optional): The file extension to look for. Defaults to 'tex'.
        % showCombinedTable (optional): Logical flag to display the combined content in the command window.

    % Outputs:
        % combinedTable: The combined content as a string with LaTeX comments.

    % Examples:
        % Combine two LaTeX files with default labels and no save path
        % combinedTable = combineTables('table1.tex', 'table2.tex');

        % Combine two text files with custom labels and save the result
        % combinedTable = combineTables('file1.txt', 'file2.txt', 'combined_file.txt', 'Label 1', 'Label 2');

    % Create an input parser object
    parser = inputParser;
    
    % Define the required inputs
    addRequired(parser, 'table1', @ischar);
    addRequired(parser, 'table2', @ischar);
    
    % Define the optional inputs
    addParameter(parser, 'savePath', '', @ischar);
    addParameter(parser, 'label1', 'Table 1', @(x) ischar(x) || isstring(x));
    addParameter(parser, 'label2', 'Table 2', @(x) ischar(x) || isstring(x));
    addParameter(parser, 'ext', 'tex', @ischar);  % Default extension is 'tex'
    addParameter(parser, 'showCombinedTable', false, @islogical);
    
    % Parse the inputs
    parse(parser, table1, table2, varargin{:});
    
    % Get the parsed inputs
    savePath = parser.Results.savePath;
    label1 = parser.Results.label1;
    label2 = parser.Results.label2;
    ext = parser.Results.ext;
    showCombinedTable = parser.Results.showCombinedTable;
    
    % Read the content of the files
    table1Content = fileread(table1);
    table2Content = fileread(table2);
    
    % Combine the content with labels as LaTeX comments
    combinedTable = sprintf('%% %s\n%s\n\n%% %s\n%s\n', label1, table1Content, label2, table2Content);
    
    % Display the combined table content if requested
    if showCombinedTable
        disp(combinedTable);
    end
    
    % If savePath is provided, save the combined content to a file
    if ~isempty(savePath)
        fid = fopen(savePath, 'w');
        if fid == -1
            error('Cannot open file for writing: %s', savePath);
        end
        fwrite(fid, combinedTable);
        fclose(fid);
    end
end
