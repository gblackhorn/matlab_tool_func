function [ciLower, ciUpper, bootstrap_pValue, bootstrapMedians, varargout] = bootstrapAnalysis(data1, varargin)
    % BOOTSTRAPANALYSIS Perform bootstrap analysis on one or two groups of data.
    % Inputs:
    % - data1: First group of data or differences (numeric array)
    % - data2 (optional): Second group of data (numeric array)
    % - Optional parameters: 'statAlpha', 'iterations', 'label'

    % Default values for optional parameters
    statAlphaDefault = 0.05;
    iterationsDefault = 1000;
    labelDefault = 'Bootstrap';

    % Check if the second input is numeric (data2)
    if ~isempty(varargin) && isnumeric(varargin{1})
        data2 = varargin{1}; % Second numeric dataset
        optionalArgs = varargin(2:end); % Remaining optional arguments
    else
        data2 = []; % No second dataset
        optionalArgs = varargin; % All arguments are optional parameters
    end

    % Parse optional inputs
    p = inputParser;
    addParameter(p, 'statAlpha', statAlphaDefault, @(x) isnumeric(x) && x > 0 && x < 1);
    addParameter(p, 'iterations', iterationsDefault, @(x) isnumeric(x) && x > 0);
    addParameter(p, 'label', labelDefault, @(x) ischar(x) || isstring(x));
    parse(p, optionalArgs{:});

    % Retrieve parsed values
    statAlpha = p.Results.statAlpha;
    iterations = p.Results.iterations;
    label = p.Results.label;

    % Check if there are two datasets or one
    if isempty(data2)
        % Single dataset (differences)
        differences = data1;
        if ~isnumeric(differences)
            error('Differences must be a numeric array.');
        end
        % Compute observed statistic
        observedMedianDiff = median(differences);
    else
        % Two datasets: data1 and data2
        if ~isnumeric(data1) || ~isnumeric(data2)
            error('Both data1 and data2 must be numeric arrays.');
        end
        % Compute observed statistic
        observedMedianDiff = median(data2) - median(data1);
    end

    % Initialize an array to store bootstrap medians
    bootstrapMedians = zeros(iterations, 1);

    % Perform bootstrap resampling
    for j = 1:iterations
        if isempty(data2)
            % Single dataset (differences)
            resampleIndices = randi(numel(differences), [numel(differences), 1]);
            bootstrapMedians(j) = median(differences(resampleIndices));
        else
            % Two datasets
            resample1 = data1(randi(numel(data1), [numel(data1), 1])); % Resample data1
            resample2 = data2(randi(numel(data2), [numel(data2), 1])); % Resample data2
            bootstrapMedians(j) = median(resample2) - median(resample1);
        end
    end

    % Determine the bootstrap confidence interval
    ciLower = prctile(bootstrapMedians, 100 * statAlpha / 2);
    ciUpper = prctile(bootstrapMedians, 100 * (1 - statAlpha / 2));

    % Calculate the bootstrap p-value
    % bootstrap_pValue = 2 * min(mean(bootstrapMedians >= observedMedianDiff), ...
    %                            mean(bootstrapMedians <= observedMedianDiff));
    bootstrap_pValue = 2 * min(mean(bootstrapMedians >= 0), mean(bootstrapMedians <= 0));

    % Create a summary table of statistics
    statMethodStr = sprintf('Bootstrap %s', label);
    statsTable = table({statMethodStr}, statAlpha, iterations, observedMedianDiff, ciLower, ciUpper, bootstrap_pValue, ...
        'VariableNames', {'Method', 'Alpha', 'Iterations', 'ObservedMedian', 'CILower', 'CIUpper', 'PValue'});

    % Assign the statsTable to varargout
    varargout{1} = statsTable;
end




