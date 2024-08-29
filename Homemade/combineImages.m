function combinedImage = combineImages(fig1, fig2, varargin)
    % Combine two images (fig1 and fig2) either horizontally (side by side) or vertically
    % (stacked one on top of the other) based on their dimensions. The function automatically
    % determines the optimal orientation by comparing the combined width and height of the images.

    % Inputs:
        % fig1 (required): The file path of the first image.
        % fig2 (required): The file path of the second image.
        % savePath (optional): The file path where the combined image will be saved. If not provided, the image will not be saved.
        % label1 (optional): The label for the first image. Defaults to 'fig1'.
        % label2 (optional): The label for the second image. Defaults to 'fig2'.

    % Outputs:
        % combinedImage: The combined image matrix with labels above each image.

    % Examples:
        % Combine two images vertically with default labels and no save path
        % combinedImage = combineImages('image1.jpg', 'image2.jpg');

        % Combine two images horizontally with custom labels and save the result
        % combinedImage = combineImages('image1.jpg', 'image2.jpg', 'combined_image.jpg', 'Custom Label 1', 'Custom Label 2');

    %Create an input parser object
    parser = inputParser;
    
    % Define the required inputs
    addRequired(parser, 'fig1', @ischar);
    addRequired(parser, 'fig2', @ischar);
    
    % Define the optional inputs
    addParameter(parser, 'savePath', '', @ischar);
    addParameter(parser, 'label1', 'fig1', @(x) ischar(x) || isstring(x));
    addParameter(parser, 'label2', 'fig2', @(x) ischar(x) || isstring(x));
    addParameter(parser, 'showCombinedFig', false, @islogical);
    
    % Parse the inputs
    parse(parser, fig1, fig2, varargin{:});
    
    % Get the parsed inputs
    % fig1 = parser.Results.fig1;
    % fig2 = parser.Results.fig2;
    savePath = parser.Results.savePath;
    label1 = parser.Results.label1;
    label2 = parser.Results.label2;
    showCombinedFig = parser.Results.showCombinedFig;
    
    % Read the images
    img1 = imread(fig1);
    img2 = imread(fig2);
    
    % Get the size of the images
    [height1, width1, ~] = size(img1);
    [height2, width2, ~] = size(img2);
    
    % Calculate combined dimensions for both orientations
    combinedWidthHorizontal = width1 + width2;
    combinedHeightHorizontal = max(height1, height2);
    
    combinedHeightVertical = height1 + height2;
    combinedWidthVertical = max(width1, width2);
    
    % Determine whether to combine horizontally or vertically
    if combinedWidthHorizontal <= combinedHeightVertical
        % Horizontal combination
        combinedImage = combineImagesWithPadding(img1, img2, label1, label2, 'horizontal', height1);
    else
        % Vertical combination
        combinedImage = combineImagesWithPadding(img1, img2, label1, label2, 'vertical', height1);
    end
    
    % Display the combined image
    if showCombinedFig
        figure;
        imshow(combinedImage);
    end
        
    % If savePath is provided, save the combined image
    if ~isempty(savePath)
        imwrite(combinedImage, savePath);
    end
end

function combinedImage = combineImagesWithPadding(img1, img2, label1, label2, orientation, height1)
    % Get the dimensions of the images
    [height1, width1, ~] = size(img1);
    [height2, width2, ~] = size(img2);
    
    % Calculate the font size as 1/30 of the height of fig1
    fontSize = round(height1 / 40);
    
    % Adjust dimensions by padding the smaller image
    if strcmp(orientation, 'horizontal')
        % Pad the shorter image in height
        if height1 > height2
            img2 = padarray(img2, [height1 - height2, 0], 255, 'post');
        elseif height2 > height1
            img1 = padarray(img1, [height2 - height1, 0], 255, 'post');
        end
        % Combine images horizontally
        combinedImage = cat(2, img1, img2);
        
        % Create a label area above the combined image
        labelArea = 255 * ones(fontSize * 2, width1 + width2, 3, 'uint8');
        labelArea = insertText(labelArea, [round(width1 / 2), fontSize / 2], label1, 'FontSize', fontSize, 'BoxColor', 'white', 'BoxOpacity', 0.7, 'AnchorPoint', 'Center');
        labelArea = insertText(labelArea, [round(width1 + width2 / 2), fontSize / 2], label2, 'FontSize', fontSize, 'BoxColor', 'white', 'BoxOpacity', 0.7, 'AnchorPoint', 'Center');
        
        % Combine the label area with the image
        combinedImage = cat(1, labelArea, combinedImage);
    else
        % Pad the narrower image in width
        if width1 > width2
            img2 = padarray(img2, [0, width1 - width2], 255, 'post');
        elseif width2 > width1
            img1 = padarray(img1, [0, width2 - width1], 255, 'post');
        end
        % Combine images vertically
        combinedImage = cat(1, img1, img2);
        
        % Create a label area above each image
        labelArea1 = 255 * ones(fontSize * 2, width1, 3, 'uint8');
        labelArea2 = 255 * ones(fontSize * 2, width2, 3, 'uint8');
        labelArea1 = insertText(labelArea1, [round(width1 / 2), fontSize / 2], label1, 'FontSize', fontSize, 'BoxColor', 'white', 'BoxOpacity', 0.7, 'AnchorPoint', 'Center');
        labelArea2 = insertText(labelArea2, [round(width2 / 2), fontSize / 2], label2, 'FontSize', fontSize, 'BoxColor', 'white', 'BoxOpacity', 0.7, 'AnchorPoint', 'Center');
        
        % Combine the label areas with the images
        combinedImage = cat(1, labelArea1, img1, labelArea2, img2);
    end
end
