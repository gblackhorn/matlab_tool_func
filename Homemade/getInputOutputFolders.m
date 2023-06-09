function [inputFolder,outputFolder,varargout] = getInputOutputFolders(varargin)
    % Use GUI to choose two folders, usually used as input and output locations 


    % Defaults
    inputFolder = ''; 
    outputFolder = ''; 

    inputMSG = 'Choose a folder for input';
    outputMSG = 'Choose a folder for output';

    % Optionals for inputs
    for ii = 1:2:(nargin)
        if strcmpi('inputFolder', varargin{ii})
            inputFolder = varargin{ii+1};
        elseif strcmpi('outputFolder', varargin{ii})
            outputFolder = varargin{ii+1};
        elseif strcmpi('inputMSG', varargin{ii})
            inputMSG = varargin{ii+1};
        elseif strcmpi('outputMSG', varargin{ii})
            outputMSG = varargin{ii+1};
        end
    end

    newInputFolder = uigetdir(inputFolder,inputMSG);
    newOutputFolder = uigetdir(outputFolder,outputMSG);

    if newInputFolder == 0
        disp('inputFolder not chosen')
        chosenStatus = false;
    else
        inputFolder = newInputFolder;
        chosenStatus = true;
    end

    if newOutputFolder == 0
        disp('outputFolder not chosen')
        chosenStatus = false;
    else
        outputFolder = newOutputFolder;
        % notChosen = false;
    end

    varargout{1} = chosenStatus;
end
