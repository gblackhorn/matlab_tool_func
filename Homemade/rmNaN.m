function [newDataset] = rmNaN(dataset,varargin)
    % Remove NaN entries

    % If dataset is an array: remove NaN entries
    % If dataset is a cell array: remove the NaN entries in the matrices in the cell array
    %   Optional input for cell array dataset: 'uniform'
    %       - If true: Combine the NaN locations from all the matrices and remove the inclusive
    %         locations from all the cells even the entries are not NaN in some of the matrices.
    %         The sizes of matrices must be the same.
    %       - If false: Remove NaN entries from every matrix


    % default
    uniform = true;

    % Optionals
    % for ii = 1:2:(nargin-2)
    %     if strcmpi('plotWhere', varargin{ii})
    %         plotWhere = varargin{ii+1}; 
    %     elseif strcmpi('titleStr', varargin{ii})
    %         titleStr = varargin{ii+1}; 
    %     end
    % end 

    % Assign the values in 'dataset' to the output 'newDataset'
    newDataset = dataset;

    % Check the class of dataset
    if isnumeric(dataset)
        % Find the locations of NaN entries in the numeric array and remove them
        idxNaN = find(isnan(dataset));
        newDataset(idxNaN) = [];
    elseif iscell(dataset)
        % Get the number of cells
        cellNum = numel(dataset);

        % Create a cell var to store the NaN locations
        idxNaN = cell(size(dataset));

        % Loop through all the cells
        for n = 1:cellNum
            idxNaN{n} = find(isnan(dataset{n}));
        end

        % Check the size of all the matrices and combine the locations of NaN entries
        if uniform
            matLength = cellfun(@numel, dataset);
            isEqual = all(matLength == matLength(1));
            if ~isEqual
                error('matrices in every cell of dataset must have the same size')
            end

            combineIdxNaN = unique(vertcat(idxNaN{:}));
        end

        % Remove the NaN entries
        for n = 1:cellNum
            if uniform
                newDataset{n}(combineIdxNaN) = [];
            else
                newDataset{n}(idxNaN{n}) = [];
            end
        end
    else
        error('The input must be a numeric array or a cell array')
    end
end
