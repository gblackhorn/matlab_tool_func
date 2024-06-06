function collectFunctionsAndCopy(mainScript, rootFolder, outputDir)
    % Check if the main script exists
    if ~exist(mainScript, 'file')
        error('The main script does not exist.');
    end
    
    % Get the list of dependencies
    dependencies = matlab.codetools.requiredFilesAndProducts(mainScript);
    
    % Ensure the root folder exists
    if ~exist(rootFolder, 'dir')
        error('The specified root folder does not exist.');
    end
    
    % Filter out dependencies that are not in the root folder
    projectDependencies = dependencies(startsWith(dependencies, rootFolder));
    
    % Ensure the output directory exists
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % Track overwrite decisions
    overwriteAll = false;
    
    % Copy the project-specific dependencies to the output directory
    for i = 1:length(projectDependencies)
        [~, name, ext] = fileparts(projectDependencies{i});
        destFile = fullfile(outputDir, [name, ext]);
        
        if exist(destFile, 'file')
            if overwriteAll
                copyfile(projectDependencies{i}, destFile);
            else
                % Ask the user whether to overwrite the existing file
                answer = input(['File ', destFile, ' already exists. Overwrite? [y/n/all]: '], 's');
                switch lower(answer)
                    case 'y'
                        copyfile(projectDependencies{i}, destFile);
                    case 'n'
                        continue;
                    case 'all'
                        overwriteAll = true;
                        copyfile(projectDependencies{i}, destFile);
                    otherwise
                        disp('Invalid input. Skipping this file.');
                end
            end
        else
            copyfile(projectDependencies{i}, destFile);
        end
    end
    
    % Inform the user
    disp(['Copied ', num2str(length(projectDependencies)), ' files to ', outputDir]);
end
