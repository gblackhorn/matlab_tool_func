function batchConvertTiffToJpg(folderPath)
    % BATCHCONVERTTIFFTOJPG Converts all TIFF files in a folder to JPG format
    % with contrast adjustment.
    %
    % Usage:
    %   batchConvertTiffToJpg(folderPath)
    %
    % Inputs:
    %   folderPath - The path to the folder containing TIFF files.

    % Get list of all TIFF files in the folder
    tiffFiles = dir(fullfile(folderPath, '*.tiff'));
    
    % If no .tiff files found, try finding .tif files
    if isempty(tiffFiles)
        tiffFiles = dir(fullfile(folderPath, '*.tif'));
    end

    % Check if any TIFF files were found
    if isempty(tiffFiles)
        disp('No TIFF files found in the specified folder.');
        return;
    end

    % Loop through each TIFF file
    for k = 1:length(tiffFiles)
        % Get the full path of the TIFF file
        tiffFilePath = fullfile(tiffFiles(k).folder, tiffFiles(k).name);

        % Read the TIFF image
        tiffImage = imread(tiffFilePath);

        % Increase the contrast of the image
        adjustedImage = imadjust(tiffImage);

        % Create the output JPG file path
        [~, fileName, ~] = fileparts(tiffFiles(k).name);
        jpgFilePath = fullfile(tiffFiles(k).folder, [fileName, '.jpg']);

        % Write the image to JPG format
        imwrite(adjustedImage, jpgFilePath, 'jpg');

        % Display progress
        fprintf('Converted %s to %s with contrast adjustment\n', tiffFiles(k).name, [fileName, '.jpg']);
    end

    disp('Batch conversion completed.');
end
