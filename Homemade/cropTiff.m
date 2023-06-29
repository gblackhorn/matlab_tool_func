function [varargout] = cropTiff(varargin)
    % Crop tiff files in a folder using the smallest size among them
    % Crop tiff files in a folder with the specified ractangle ([xmin ymin width height])

    % Default
    folder = '';
    rect = []; % [xmin ymin width height]
    useMinSize = false; % true/false. Use the resolution size of the smallest tiff. This has higher priority than rect
    cropSuffix = '-cropped'; % add the cropSuffix to the end of file name 

    % 'WriteMode', 'append', 'Compression', 'none'
    % 'WriteMode', 'overwrite', 'Compression', 'none'
    options = {'WriteMode', 'append', 'Compression', 'none'}; 

    % Optionals
    for ii = 1:2:(nargin)
        if strcmpi('folder', varargin{ii})
            folder = varargin{ii+1}; % struct var including fields 'cat_type', 'cat_names' and 'cat_merge'
        elseif strcmpi('rect', varargin{ii})
            rect = varargin{ii+1};
        elseif strcmpi('useMinSize', varargin{ii})
            useMinSize = varargin{ii+1};
        % elseif strcmpi('nonstimMean_pos', varargin{ii})
        %     nonstimMean_pos = varargin{ii+1};
        end
    end   

    % get the input folder
    [inputFolder,outputFolder] = getInputOutputFolders('inputFolder',folder,'outputFolder',folder);


    % look for tiff files
    tiffList = dir(fullfile(inputFolder,'*.tif*'));
    tiffNum = numel(tiffList);


    % get the width and height of the tiff files
    if cropSuffix
        for n = 1:tiffNum
            tiffInfo = imfinfo(fullfile(tiffList(n).folder,tiffList(n).name));
            tiffList(n).width = tiffInfo.Width;
            tiffList(n).height = tiffInfo.Height;
            tiffList(n).frameNum = numel(tiffInfo);
        end 
    end

    clear tiffInfo


    % get the smallest width and height
    [minWidth, minWidthIDX] = min([tiffList.width]);
    [minHeight, minHeightIDX] = min([tiffList.height]);

    if useMinSize
        rect = [0 0 minWidth minHeight];
    else
        if isempty(rect)
            error('either set useMinSize as true or use rect for cropping the tiff files');
        end
    end

    % loop through the tiff files, and crop them
    for n = 1:tiffNum
        [~,tiffName,tiffExt]=fileparts(tiffList(n).name);


        fprintf('Cropping file [%s] with rectangle [%g %g %g %g] [minX minY width height]\n',...
            tiffList(n).name,rect(1),rect(2),rect(3),rect(4));


        % Read the TIFF stack
        tiffFullPath = fullfile(tiffList(n).folder,tiffList(n).name);
        firstImg = imread(tiffFullPath, 'Index', 1);

        croppedFileName = [tiffName,cropSuffix,tiffExt];
        croppedTiffFullPath = fullfile(tiffList(n).folder,croppedFileName);

        % % Preallocate memory for the cropped stack
        % clear croppedStack
        % croppedStack = zeros(minHeight,minWidth,tiffList(n).frameNum);

        % Crop each frame of the stack
        for i = 1:tiffList(n).frameNum
            frame = imread(tiffFullPath,'Index',i);
            croppedFrame = imcrop(frame,rect);

            % croppedStack(:, :, i) = croppedFrame;
            % imwrite(croppedStack(:, :, i),croppedTiffFullPath,'tif',options{:});

            imwrite(croppedFrame,croppedTiffFullPath,'tif',options{:});
        end

        % imwrite(croppedStack,croppedTiffFullPath,'tif',options{:});
    end

    varargout{1} = inputFolder;
    varargout{2} = outputFolder;
end

