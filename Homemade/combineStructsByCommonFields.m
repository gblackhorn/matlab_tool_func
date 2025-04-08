function combinedStruct = combineStructsByCommonFields(structCell, debugMode)
% COMBINESTRUCTSBYCOMMONFIELDS:
%   Takes a cell array of struct arrays, each possibly having a different
%   set of fields. It finds the intersection (common fields) across all
%   and returns a single struct array containing only those common fields.
%
%   Usage:
%       combinedStruct = combineStructsByCommonFields(structCell, debugMode);
%
%   Input:
%       structCell  - A cell array, where each cell contains a struct array
%                     (e.g., 1xN or Nx1). 
%       debugMode   - (Optional) A boolean flag to enable debug mode. Default is false.
%
%   Output:
%       combinedStruct - A single struct array (1×M) containing only the 
%                        fields common to all input struct arrays.

    if nargin < 2
        debugMode = false;
    end

    % If the cell array is empty, return an empty struct
    if isempty(structCell)
        combinedStruct = struct([]);
        return;
    end

    % 1) Collect the fieldnames from the first non-empty struct array
    nonEmptyIdx = find(~cellfun(@isempty, structCell), 1);
    if isempty(nonEmptyIdx)
        combinedStruct = struct([]);
        return;
    end
    commonFields = fieldnames(structCell{nonEmptyIdx});
    if debugMode
        fprintf('Step 1: Collected initial common fields.\n');
    end

    % 2) Intersect with fieldnames of subsequent non-empty struct arrays
    for i = nonEmptyIdx+1:numel(structCell)
        if isempty(structCell{i})
            continue;
        end
        currentFields = fieldnames(structCell{i});
        commonFields = intersect(commonFields, currentFields);
        if debugMode
            fprintf('Step 2: Intersected with struct array %d.\n', i);
        end
    end

    % 3) Remove any extra fields in each non-empty struct array
    for i = 1:numel(structCell)
        if isempty(structCell{i})
            continue;
        end
        S = structCell{i};
        extraFields = setdiff(fieldnames(S), commonFields);
        if ~isempty(extraFields)
            S = rmfield(S, extraFields);
            if debugMode
                fprintf('Step 3: Removed extra fields from struct array %d.\n', i);
            end
        end
        
        % No dimension reshape here; we keep S as it is
        structCell{i} = S;
    end

    % 4) Concatenate all non-empty struct arrays horizontally
    %    This results in a single row vector of structs: 1 x (N1 + N2 + ...)
    combinedStruct = [structCell{~cellfun(@isempty, structCell)}];
    if debugMode
        fprintf('Step 4: Concatenated all struct arrays.\n');
    end
end
