function [] = batchMod_fileName(FolderPath,oldStr,newStr,varargin)
    % Batch modify the file names in a selected folder
    % Replace the characters in the oldStr with the newStr

    % Defaults
    keyword = ''; % Use keyword to filter files in the FolderPath
    overwrite = false; % true/false. Create new DFF files if this is true.

    % Optionals
    for ii = 1:2:(nargin-2)
        if strcmpi('keyword', varargin{ii})
            keyword = varargin{ii+1}; 
        elseif strcmpi('overwrite', varargin{ii})
            overwrite = varargin{ii+1};
        % elseif strcmpi('stimStart_err', varargin{ii})
        %     stimStart_err = varargin{ii+1};
        % elseif strcmpi('nonstimMean_pos', varargin{ii})
        %     nonstimMean_pos = varargin{ii+1};
        end
    end 

    % Get the file list
    if isempty(keyword)
        filesInfo = dir(FolderPath);
        filesInfo = filesInfo(3:end); % exclud . and .. entries
    else
        filesInfo = dir(fullfile(FolderPath,['*',keyword]));
    end
    fileNum = numel(filesInfo);


    % loop through files and modify their names
    mod_fileNum = 0;
    for n = 1:fileNum
        oldName = filesInfo(n).name;
        oldFullPath = fullfile(filesInfo(n).folder,filesInfo(n).name);

        newName = strrep(oldName,oldStr,newStr);
        newFullPath = fullfile(filesInfo(n).folder,newName);

        if ~exist(newFullPath,'file') || overwrite == true
            movefile(oldFullPath,newFullPath);
            fprintf(' - New file name: %s\n',newFullPath);
            mod_fileNum = mod_fileNum+1;
        end
    end

    fprintf('\n%g file names were modified',mod_fileNum);
end