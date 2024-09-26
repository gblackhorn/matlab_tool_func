function [ciLower, ciUpper, bootstrap_pValue, bootstrapMedians, varargout] = bootstrapAnalysis(data1, varargin)
    % BOOTSTRAPANALYSIS Perform bootstrap analysis on two groups or a single
    % differences dataset.
    % This function calculates the confidence interval and p-value for the
    % difference in medians between two groups using bootstrap resampling.
    %
    % Inputs:
    % - data1: First group of data or differences (numeric array)
    % - data2 (optional): Second group of data (numeric array)
    % - 'alpha' (optional): Significance level for confidence intervals (default: 0.05)
    % - 'iterations' (optional): Number of bootstrap iterations (default: 1000)
    %
    % Outputs:
    % - ciLower: Lower bound of the bootstrap confidence interval
    % - ciUpper: Upper bound of the bootstrap confidence interval
    % - bootstrap_pValue: Bootstrap p-value for the difference in medians
    % - bootstrapMedians: Array of bootstrap medians from each iteration
    % - varargout: A table containing summary statistics
    
    % Parse optional inputs
    p = inputParser;
    addParameter(p, 'statAlpha', 0.05, @(x) isnumeric(x) && x > 0 && x < 1);
    addParameter(p, 'iterations', 1000, @(x) isnumeric(x) && x > 0);
    addParameter(p, 'label', '1000', @ischar);
    parse(p, varargin{:});
    
    statAlpha = p.Results.statAlpha;
    iterations = p.Results.iterations;
    label = p.Results.label;
    
    % Check if one or two data inputs are provided
    if numel(varargin) >= 1 && isnumeric(varargin{1})
        data2 = varargin{1};
        % Calculate the differences between the two groups
        differences = data2 - data1;
    else
        % Assume the single input is the differences
        differences = data1;
    end
    
    % Check if the differences data are numeric
    if ~isnumeric(differences)
        error('Differences must be a numeric array.');
    end
    
    % Initialize an array to store bootstrap medians
    bootstrapMedians = zeros(iterations, 1);
    
    % Perform bootstrap resampling
    for j = 1:iterations
        % Resample with replacement
        resampleIndices = randi(numel(differences), [numel(differences), 1]);
        % Compute the median of the resampled differences
        bootstrapMedians(j) = median(differences(resampleIndices));
    end
    
    % Calculate the observed median difference
    observedMedian = median(differences);
    
    % Determine the bootstrap confidence interval
    ciLower = prctile(bootstrapMedians, 100 * statAlpha / 2);
    ciUpper = prctile(bootstrapMedians, 100 * (1 - statAlpha / 2));
    
    % Calculate the bootstrap p-value
    bootstrap_pValue = 2 * min(mean(bootstrapMedians >= 0), mean(bootstrapMedians <= 0));
    
    % Create a summary table of statistics
    statMethodStr = sprintf('Bootstrap %s', label);
    statsTable = table({statMethodStr}, statAlpha, iterations, observedMedian, ciLower, ciUpper, bootstrap_pValue, ...
        'VariableNames', {'Method', 'Alpha', 'Iterations', 'ObservedMedian', 'CILower', 'CIUpper', 'PValue'});
    
    % Assign the statsTable to varargout
    varargout{1} = statsTable;
    
    % % Display results (optional)
    % fprintf('Observed Median Difference: %.4f\n', observedMedian);
    % fprintf('Bootstrap CI: [%.4f, %.4f]\n', ciLower, ciUpper);
    % fprintf('Bootstrap p-value: %.4f\n', bootstrap_pValue);
end



