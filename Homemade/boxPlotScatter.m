function [boxInfo, varargout] = boxPlotScatter(boxData, varargin)
    % boxPlotScatter creates box plots with scatter points, styled similarly to bar plots.
    % boxData: numeric or cell array
    %   - Row vector: each number is a box plot value
    %   - Column vector: each column is for a box plot
    %   - Cell array: each cell represents a separate box plot

    % Defaults
    jitterAmount = 0.5; % Amount of jitter added to scatter points to avoid overlap

    % Create input parser to handle input arguments
    p = inputParser;

    % Required argument
    addRequired(p, 'boxData', @(x) isnumeric(x) || iscell(x)); % Accepts numeric data or cell array

    % Optional parameters with default values (mirroring bar plot function)
    addParameter(p, 'boxNamePrefix', 'Category', @ischar);
    addParameter(p, 'unit_width', 0.4, @isnumeric);
    addParameter(p, 'unit_height', 0.4, @isnumeric);
    addParameter(p, 'column_lim', 1, @isnumeric);
    addParameter(p, 'TickAngle', 0, @isnumeric);
    addParameter(p, 'boxEdgeColor', 'k', @ischar);
    addParameter(p, 'boxFaceColor', '#4D4D4D', @ischar);
    addParameter(p, 'FontSize', 14, @isnumeric);
    addParameter(p, 'FontWeight', 'bold', @ischar);
    addParameter(p, 'plotWhere', []); % Axes to plot on, if specified
    addParameter(p, 'barX', [], @isnumeric); % Corrected to include 'barX'
    addParameter(p, 'barNames', [], @(x) iscell(x) || ischar(x)); % Corrected to match the bar plot function

    % Parse inputs to retrieve parameters
    parse(p, boxData, varargin{:});

    % Assign parsed values to variables
    params = p.Results;

    % Create a new figure window or use the existing axis if 'plotWhere' variable exists
    if isempty(params.plotWhere)
        figure('Units', 'normalized', 'Position', [0.1, 0.1, params.unit_width, params.unit_height]);
    else
        axes(params.plotWhere);
    end
    hold on;

    % Process input data and calculate values needed for plotting
    [boxVal, dataNumVal, boxNum] = calculateBoxValues(params.boxData);

    % Set default x positions if not provided
    if isempty(params.barX)
        params.barX = 1:boxNum;
    end

    % Box name for each plot
    if isempty(params.barNames)
        params.barNames = arrayfun(@(x) sprintf('%s %d', params.boxNamePrefix, x), 1:boxNum, 'UniformOutput', false);
    end

    % Plot each box plot at the specified position
    for i = 1:boxNum
        validData = boxVal{i}(~isnan(boxVal{i})); % Remove NaNs for plotting
        if ~isempty(validData)
            boxplot(validData, 'Positions', params.barX(i), 'Widths', 0.5, ...
                'Colors', params.boxEdgeColor, 'Symbol', '', 'Labels', {params.barNames{i}});
        end
    end

    % Add scatter points with jitter to visualize individual data points
    plotScatterWithJitter(params.boxData, params.barX, boxNum, jitterAmount);

    % Add data number to the bottom of each box
    addDataNumber(params.barX, dataNumVal);

    % Style the plot to match bar plot style
    stylePlot(gca, params.TickAngle, params.FontSize, params.FontWeight, params.barNames, params.barX);

    % Save the calculated data (original data grouped) to a structure
    boxInfo = struct('boxNames', params.barNames, 'boxVal', {boxVal});

    hold off;
end

function [boxVal, dataNumVal, boxNum] = calculateBoxValues(boxData)
    % Calculate the box values from the input data
    if isnumeric(boxData) && isrow(boxData)
        boxVal = num2cell(boxData); % Single row vector, each element is a separate box plot
        boxNum = numel(boxData);
        dataNumVal = ones(1, boxNum); % Each plot has one data point
    elseif isnumeric(boxData) && ismatrix(boxData)
        boxVal = arrayfun(@(cn) boxData(:, cn), 1:size(boxData, 2), 'UniformOutput', false);
        boxNum = size(boxData, 2);
        dataNumVal = cellfun(@(x) sum(~isnan(x)), boxVal);
    elseif iscell(boxData)
        boxVal = boxData; % Directly use the cell array as each group
        boxNum = numel(boxData);
        dataNumVal = cellfun(@(x) sum(~isnan(x)), boxData);
    end
end

function plotScatterWithJitter(boxData, barX, boxNum, jitterAmount)
    % Plot scatter points with jitter to visualize individual data points
    if isnumeric(boxData) && ismatrix(boxData)
        for cn = 1:boxNum
            jitterX = barX(cn) + (rand(size(boxData(:, cn))) - 0.5) * jitterAmount;
            scatter(jitterX, boxData(:, cn), 18, 'k', 'filled');
        end
    elseif iscell(boxData)
        for cn = 1:boxNum
            validData = boxData{cn}(~isnan(boxData{cn})); % Filter out NaN values
            jitterX = barX(cn) + (rand(length(validData), 1) - 0.5) * jitterAmount;
            scatter(jitterX, validData, 18, 'k', 'filled');
        end
    end
end

function addDataNumber(barX, dataNumVal)
    % Add the number of data points at the bottom of each box
    yL = ylim;
    nNumYval = yL(1) + 0.05 * (yL(2) - yL(1));
    nNumY = repmat(nNumYval, 1, numel(barX));
    nNumStr = arrayfun(@num2str, dataNumVal, 'UniformOutput', false);
    text(barX, nNumY, nNumStr, 'vert', 'bottom', 'horiz', 'center', 'Color', 'white');
end

function stylePlot(gcaHandle, TickAngle, FontSize, FontWeight, barNames, barX, varargin)
    % Style the plot to match the bar plot
    % Added optional 'yTickInterval' parameter for customizable y-ticks
    
    % Parse optional inputs
    p = inputParser;
    addOptional(p, 'yTickInterval', 2, @isnumeric); % Default interval is 2
    parse(p, varargin{:});
    yTickInterval = p.Results.yTickInterval;

    % Modify x-axis
    set(gcaHandle, 'box', 'off');
    set(gcaHandle, 'TickDir', 'out');
    set(gcaHandle, 'FontSize', FontSize);
    set(gcaHandle, 'FontWeight', FontWeight);
    xtickangle(TickAngle);
    set(gcaHandle, 'XTick', barX);
    set(gcaHandle, 'xticklabel', barNames);

    % Customize y-axis ticks
    yLimits = ylim(gcaHandle);
    yTicks = floor(yLimits(1)/yTickInterval)*yTickInterval : yTickInterval : ceil(yLimits(2)/yTickInterval)*yTickInterval;
    set(gcaHandle, 'YTick', yTicks);
    set(gcaHandle, 'YTickLabel', arrayfun(@num2str, yTicks, 'UniformOutput', false));
end

