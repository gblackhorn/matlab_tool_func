function [varargout] = rmFilesWithKeywords(targetFolder,keyword,varargin)
	% Find files with 'keyword' in the 'targetFolder' and delete them

	% use * to replace uncertain parts in the 'keyword'

	% Defaults
	gui = true; % use GUI to select the targetFolder
	showFileList = false; % true/false. If true, display the list of files to be deleted

	% Optionals
	for ii = 1:2:(nargin-2)
	    if strcmpi('gui', varargin{ii})
	        gui = varargin{ii+1}; 
	    elseif strcmpi('showFileList', varargin{ii}) 
	        showFileList = varargin{ii+1};
	    % elseif strcmpi('guiSave', varargin{ii})
        %     guiSave = varargin{ii+1};
	    % elseif strcmpi('fname', varargin{ii})
        %     fname = varargin{ii+1};
	    end
	end

	guiMsg = sprintf('Select a folder to delete the files with keyword: %s',keyword);

	if gui
		targetFolder = uigetdir(targetFolder,guiMsg);
		if targetFolder == 0 
			disp('no folder chosen. nothing will be deleted')
			return
		else
			varargout{1} = targetFolder;
		end
	end

	fileFolderContent = dir(fullfile(targetFolder,keyword));
	if ~isempty(fileFolderContent)
		fileNum = numel(fileFolderContent);

		disp(targetFolder)
		confirmDeleteMsg = sprintf('Delete %g files with keyword (%s) in the folder above\n(y)yes or (n)no? [default-y]:',...
			fileNum,keyword);
		confirmDeletInput = input(confirmDeleteMsg,'s');
		if isempty(confirmDeletInput)
			confirmDeletInput = 'y';
		end

		switch confirmDeletInput
			case 'y'
				for fn = 1:fileNum
					filePath = fullfile(targetFolder,fileFolderContent(fn).name);
					delete(filePath);
					if showFileList
						deleteMsg = sprintf('delete: %s',filePath);
						disp(deleteMsg)
					end
				end
				disp('all files deleted')
			case 'n'
				return
			otherwise
				error('only y and n are accepted as input')
		end
	else
		disp('no files with keyword found. nothing will be deleted')
	end
end