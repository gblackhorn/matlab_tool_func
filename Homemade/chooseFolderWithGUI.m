function folderPath = chooseFolderWithGUI(varargin)
    % Default starting path is the current working directory
    startPath = pwd;
    
    % Default dialog title
    dialogTitle = 'Select a Folder';

    % Handle optional input arguments
    if nargin >= 1
        startPath = varargin{1};  % Custom starting path
    end
    if nargin == 2
        dialogTitle = varargin{2};  % Custom dialog title
    end

    % Open folder selection dialog
    folderPath = uigetdir(startPath, dialogTitle);

    % Check if the user pressed Cancel
    if folderPath == 0
        error('No folder selected. Operation cancelled.');
    else
        disp(['Selected folder: ', folderPath]);
    end
end
