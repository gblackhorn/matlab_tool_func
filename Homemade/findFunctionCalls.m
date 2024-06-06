function callerFiles = findFunctionCalls(targetFolder, targetFunction)
    % FINDFUNCTIONCALLS Searches for calls to a specified function in all .m files within the target folder and its subfolders.
    %
    %   callerFiles = FINDFUNCTIONCALLS(targetFolder, targetFunction) returns a
    %   cell array of paths to .m files that call the specified targetFunction.
    %
    %   Input arguments:
    %   - targetFolder: The folder to search (string).
    %   - targetFunction: The function name to search for (string).
    %
    %   Output:
    %   - callerFiles: A cell array of paths to .m files that call the specified function.
    %
    %   Example:
    %   - findFunctionCalls('D:\guoda\Documents\MATLAB\Codes', 'barplot_with_stat');

    % Get list of all .m files in the target folder and subfolders
    fileList = dir(fullfile(targetFolder, '**', '*.m'));

    % Initialize the cell array to hold the caller files
    callerFiles = {};

    % Loop through each file and check for the target function call
    for k = 1:length(fileList)
        % Get the full path of the current file
        filePath = fullfile(fileList(k).folder, fileList(k).name);
        
        % Read the content of the file
        fileContent = fileread(filePath);
        
        % Skip the file if it defines the target function
        if isFunctionDefinedInFile(fileContent, targetFunction)
            continue;
        end
        
        % Check if the target function is called in the file
        if isFunctionCalledInFile(fileContent, targetFunction)
            % Add the file path to the callerFiles cell array
            callerFiles{end+1} = filePath; %#ok<AGROW>
        end
    end

    % Display the results
    if isempty(callerFiles)
        disp(['No files found calling the function ', targetFunction, '.']);
    else
        disp(['Files calling the function ', targetFunction, ':']);
        disp(callerFiles');
    end
end

function isDefined = isFunctionDefinedInFile(fileContent, functionName)
    % ISFUNCTIONDEFINEDINFILE Checks if a function is defined in the given file content
    %
    %   isDefined = ISFUNCTIONDEFINEDINFILE(fileContent, functionName) returns true if
    %   the function is defined in the file content, otherwise returns false.
    
    % Remove comments and strings for accurate parsing
    fileContent = regexprep(fileContent, '%.*', ''); % Remove comments
    fileContent = regexprep(fileContent, '["''].*?["'']', ''); % Remove strings
    
    % Define patterns to match function definitions
    functionPattern = ['function\s*.*=\s*', functionName, '\s*\(']; % Handles function definitions with outputs
    functionPattern2 = ['function\s*', functionName, '\s*\(']; % Handles function definitions without outputs
    
    % Check for the patterns in the file content
    isDefined = ~isempty(regexp(fileContent, functionPattern, 'once')) || ...
                ~isempty(regexp(fileContent, functionPattern2, 'once'));
end

function isCalled = isFunctionCalledInFile(fileContent, functionName)
    % ISFUNCTIONCALLEDINFILE Checks if a function is called in the given file content
    %
    %   isCalled = ISFUNCTIONCALLEDINFILE(fileContent, functionName) returns true if
    %   the function is called in the file content, otherwise returns false.
    
    % Define a pattern to match function calls
    callPattern = [functionName, '\s*\('];
    
    % Check for the pattern in the file content
    isCalled = ~isempty(regexp(fileContent, callPattern, 'once'));
end
