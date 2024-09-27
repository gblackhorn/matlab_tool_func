function pairedFiles = findFilePairs(folderPath, file1Keyword, file2Keyword, varargin)
    % findFilePairs finds pairs of related files based on specified keywords.
    %
    % This function searches for pairs of files in a specified folder. It identifies
    % files containing two required keywords (file1Keyword and file2Keyword) and
    % an optional keyword (optionalKeyword). Files are paired if they share a common
    % prefix before the required keyword.
    %
    % Inputs:
    %   folderPath       - (char or string) The path to the folder containing the files.
    %   file1Keyword     - (char or string) A keyword to identify the first set of files.
    %   file2Keyword     - (char or string) A keyword to identify the second set of files.
    %   optionalKeyword  - (char or string, optional) A keyword that must be present in both
    %                      file1 and file2 files. Default is an empty string ('').
    %
    % Outputs:
    %   pairedFiles      - (cell array) A cell array containing pairs of file names
    %                      that match the specified criteria.
    %
    % Example:
    %   % Example directory structure:
    %   % folderPath/
    %   %   - sample_peak_delta_norm_hpstd meanSemTab nNumInfo.tex
    %   %   - sample_peak_delta_norm_hpstd modelCompTab.tex
    %   %
    %   % Find paired files using keywords:
    %   pairedFiles = findFilePairs('folderPath', 'meanSemTab nNumInfo', ...
    %                               'modelCompTab', 'peak_delta_norm_hpstd');
    %   disp(pairedFiles);
    %   % Output:
    %   %   {'sample_peak_delta_norm_hpstd meanSemTab nNumInfo.tex', ...
    %   %    'sample_peak_delta_norm_hpstd modelCompTab.tex'}
    %

    % Create an input parser object to handle and validate inputs
    p = inputParser;

    % Define required inputs
    addRequired(p, 'folderPath', @(x) ischar(x) || isstring(x));
    addRequired(p, 'file1Keyword', @(x) ischar(x) || isstring(x));
    addRequired(p, 'file2Keyword', @(x) ischar(x) || isstring(x));

    % Define optional parameters with default values
    addParameter(p, 'optionalKeyword', '', @(x) ischar(x) || isstring(x));

    % Parse the inputs and handle any errors in input validation
    parse(p, folderPath, file1Keyword, file2Keyword, varargin{:});

    % Retrieve parsed input values
    folderPath = p.Results.folderPath;
    file1Keyword = p.Results.file1Keyword;
    file2Keyword = p.Results.file2Keyword;
    optionalKeyword = p.Results.optionalKeyword;

    % Construct search pattern for dir based on optionalKeyword
    if isempty(optionalKeyword)
        searchPattern = '*.tex'; % No filtering on optionalKeyword
    else
        searchPattern = ['*' optionalKeyword '*.tex']; % Filter files with optionalKeyword
    end

    % List all matching .tex files in the directory
    files = dir(fullfile(folderPath, searchPattern));
    fileList = {files.name};

    % Filter filenames using cellfun for each keyword
    isFile1 = cellfun(@(x) contains(x, file1Keyword), fileList); % Files matching file1Keyword
    isFile2 = cellfun(@(x) contains(x, file2Keyword), fileList); % Files matching file2Keyword

    % Extract matched files into separate lists
    file1List = fileList(isFile1);
    file2List = fileList(isFile2);

    % Initialize an empty cell array to store paired files
    pairedFiles = {};
    for i = 1:length(file1List)
        % Extract the prefix before the file1Keyword to find matching pairs
        prefix = extractBefore(file1List{i}, file1Keyword);
        % Find matching file2Keyword files with the same prefix
        match = file2List(contains(file2List, [prefix file2Keyword]));
        if ~isempty(match)
            pairedFiles{end+1} = {file1List{i}, match{1}};  % Store the file pair
        end
    end
end
