function vertConcatLatexTab(folderPath, fileKeyword, tableCaption)
    % vertConcatLatexTab Concatenates multiple LaTeX tables vertically into one table.
    %
    % This function finds LaTeX tables in the given folder that match the file keyword,
    % extracts the table content, and combines them into one table using the first
    % file's header. A new table is written to a single LaTeX file with the specified
    % caption.
    %
    % Inputs:
    %   folderPath - The path to the folder containing the LaTeX files.
    %   fileKeyword - A keyword to identify the relevant LaTeX files.
    %   tableCaption - The caption for the concatenated table.

    % List all files in the directory matching the fileKeyword
    texFiles = dir(fullfile(folderPath, ['*' fileKeyword '*.tex']));
    if isempty(texFiles)
        error('No files found with the specified keyword.');
    end
    
    % Initialize containers for header and rows
    combinedRows = {};
    header = '';
    
    % Loop through each file and extract relevant content
    for i = 1:length(texFiles)
        fileName = fullfile(folderPath, texFiles(i).name);
        fileContent = fileread(fileName);
        
        % Extract the table content from the file
        [fileHeader, tabRows, ~, ~] = extractLatexTabContent(fileContent);
        
        if i == 1
            % Use the first file's header as the final header
            header = fileHeader;
        end
        
        % Add rows from this file to the combined rows (flatten the cell array)
        combinedRows = [combinedRows tabRows];  % Append rows
        
        % Add \hline after each file's rows
        combinedRows{end+1} = '\hline';
    end
    
    % Construct the LaTeX table content
    numColumns = length(strsplit(header, '&'));
    tabularxLine = ['\begin{tabularx}{\linewidth}{', repmat('|X', 1, numColumns), '|}'];
    
    % Build the LaTeX table
    newTableContent = {};
    newTableContent{end+1} = '\begin{table}[htbp]';
    newTableContent{end+1} = ['\caption{' tableCaption '}'];
    newTableContent{end+1} = '\centering';
    newTableContent{end+1} = tabularxLine;
    newTableContent{end+1} = '\hline';
    newTableContent{end+1} = header;
    newTableContent{end+1} = '\hline';
    
    % Add all concatenated rows (already flattened)
    newTableContent = [newTableContent combinedRows];
    
    % End the table
    newTableContent{end+1} = '\end{tabularx}';
    newTableContent{end+1} = sprintf('\\label{tab:%s}', tableCaption);
    newTableContent{end+1} = '\end{table}';
    newTableContent{end+1} = '\FloatBarrier % Force LaTeX to place this table before continuing';
    
    % Write the final LaTeX table to a new file
    outputFileName = sprintf('%s.tex', tableCaption);
    outputFilePath = fullfile(folderPath, outputFileName);
    fid = fopen(outputFilePath, 'w');
    
    % Write out the content, ensuring the cell content is expanded correctly
    for k = 1:length(newTableContent)
        if iscell(newTableContent{k})
            fprintf(fid, '%s\n', newTableContent{k}{:});  % For multi-line cells
        else
            fprintf(fid, '%s\n', newTableContent{k});     % For single-line strings
        end
    end
    
    fclose(fid);
    
    % Inform the user
    fprintf('Concatenated LaTeX table saved to: %s\n', outputFilePath);
end