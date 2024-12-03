function [pValue, signedRankStats, varargout] = signedRankAnalysis(data1, varargin)
    % SIGNEDRANKANALYSIS Perform the Wilcoxon Signed-Rank Test.
    % Handles cases where data contains only NaNs.
    %
    % Inputs:
    % - data1: First dataset or paired differences (numeric array)
    % - data2 (optional): Second dataset for paired data (numeric array)
    % - Optional parameters: 'statAlpha', 'label'
    %
    % Outputs:
    % - pValue: The p-value of the test
    % - signedRankStats: The signed-rank statistic
    % - varargout: A summary table of the results

    % Default values for optional parameters
    statAlphaDefault = 0.05;
    labelDefault = 'Signed-Rank';

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
    addParameter(p, 'label', labelDefault, @(x) ischar(x) || isstring(x));
    parse(p, optionalArgs{:});

    % Retrieve parsed values
    statAlpha = p.Results.statAlpha;
    label = p.Results.label;

    % Compute paired differences if two datasets are provided
    if isempty(data2)
        differences = data1; % Assume the input is already paired differences
    else
        % Check that data1 and data2 have the same size
        if numel(data1) ~= numel(data2)
            error('data1 and data2 must have the same number of elements.');
        end
        differences = data2 - data1; % Compute paired differences
    end

    % Ensure differences are numeric
    if ~isnumeric(differences)
        error('Paired differences must be a numeric array.');
    end

    % Handle cases where all data are NaN
    if all(isnan(differences))
        % Fill outputs with NaN
        pValue = NaN;
        signedRankStats = NaN;
        hValue = NaN;
    else
        % Remove NaN values for computation
        validDifferences = differences(~isnan(differences));

        % Perform the Wilcoxon Signed-Rank Test
        [pValue, ~, stats] = signrank(validDifferences);

        % Determine hypothesis test result
        hValue = pValue < statAlpha;

        % Extract the signed-rank statistic
        signedRankStats = stats.signedrank;
    end

    % Create a summary table of results
    statMethodStr = sprintf('Wilcoxon %s', label);
    resultsTable = table({statMethodStr}, statAlpha, signedRankStats, pValue, hValue, ...
        'VariableNames', {'Method', 'Alpha', 'SignedRank', 'PValue', 'HValue'});

    % Assign the resultsTable to varargout
    varargout{1} = resultsTable;
end
