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
    bootstrap_pValue = 2 * min(mean(bootstrapMedians >= observedMedianDiff), ...
                               mean(bootstrapMedians <= observedMedianDiff));

    % Create a summary table of statistics
    statMethodStr = sprintf('Bootstrap %s', label);
    statsTable = table({statMethodStr}, statAlpha, iterations, observedMedianDiff, ciLower, ciUpper, bootstrap_pValue, ...
        'VariableNames', {'Method', 'Alpha', 'Iterations', 'ObservedMedian', 'CILower', 'CIUpper', 'PValue'});

    % Assign the statsTable to varargout
    varargout{1} = statsTable;
end




% function [ciLower, ciUpper, bootstrap_pValue, bootstrapMedians, varargout] = bootstrapAnalysis(data1, varargin)
%     % BOOTSTRAPANALYSIS Perform bootstrap analysis on two groups or a single
%     % differences dataset.
%     % This function calculates the confidence interval and p-value for the
%     % difference in medians between two groups using bootstrap resampling.
%     %
%     % Inputs:
%     % - data1: First group of data or differences (numeric array)
%     % - data2 (optional): Second group of data (numeric array)
%     % - 'alpha' (optional): Significance level for confidence intervals (default: 0.05)
%     % - 'iterations' (optional): Number of bootstrap iterations (default: 1000)
%     %
%     % Outputs:
%     % - ciLower: Lower bound of the bootstrap confidence interval
%     % - ciUpper: Upper bound of the bootstrap confidence interval
%     % - bootstrap_pValue: Bootstrap p-value for the difference in medians
%     % - bootstrapMedians: Array of bootstrap medians from each iteration
%     % - varargout: A table containing summary statistics
    
%     % Parse optional inputs
%     p = inputParser;
%     addParameter(p, 'statAlpha', 0.05, @(x) isnumeric(x) && x > 0 && x < 1);
%     addParameter(p, 'iterations', 1000, @(x) isnumeric(x) && x > 0);
%     addParameter(p, 'label', '1000', @ischar);
%     parse(p, varargin{:});
    
%     statAlpha = p.Results.statAlpha;
%     iterations = p.Results.iterations;
%     label = p.Results.label;
    
%     % Check if one or two data inputs are provided
%     if numel(varargin) >= 1 && isnumeric(varargin{1})
%         data2 = varargin{1};
%         % Calculate the differences between the two groups
%         differences = data2 - data1;
%     else
%         % Assume the single input is the differences
%         differences = data1;
%     end
    
%     % Check if the differences data are numeric
%     if ~isnumeric(differences)
%         error('Differences must be a numeric array.');
%     end
    
%     % Initialize an array to store bootstrap medians
%     bootstrapMedians = zeros(iterations, 1);
    
%     % Perform bootstrap resampling
%     for j = 1:iterations
%         % Resample with replacement
%         resampleIndices = randi(numel(differences), [numel(differences), 1]);
%         % Compute the median of the resampled differences
%         bootstrapMedians(j) = median(differences(resampleIndices));
%     end
    
%     % Calculate the observed median difference
%     observedMedian = median(differences);
    
%     % Determine the bootstrap confidence interval
%     ciLower = prctile(bootstrapMedians, 100 * statAlpha / 2);
%     ciUpper = prctile(bootstrapMedians, 100 * (1 - statAlpha / 2));
    
%     % Calculate the bootstrap p-value
%     bootstrap_pValue = 2 * min(mean(bootstrapMedians >= 0), mean(bootstrapMedians <= 0));
    
%     % Create a summary table of statistics
%     statMethodStr = sprintf('Bootstrap %s', label);
%     statsTable = table({statMethodStr}, statAlpha, iterations, observedMedian, ciLower, ciUpper, bootstrap_pValue, ...
%         'VariableNames', {'Method', 'Alpha', 'Iterations', 'ObservedMedian', 'CILower', 'CIUpper', 'PValue'});
    
%     % Assign the statsTable to varargout
%     varargout{1} = statsTable;
    
%     % % Display results (optional)
%     % fprintf('Observed Median Difference: %.4f\n', observedMedian);
%     % fprintf('Bootstrap CI: [%.4f, %.4f]\n', ciLower, ciUpper);
%     % fprintf('Bootstrap p-value: %.4f\n', bootstrap_pValue);
% end



