function combinedStruct = combineStructsByCommonFields(structCell)
% COMBINESTRUCTSBYCOMMONFIELDS:
%   Takes a cell array of struct arrays, each possibly having a different
%   set of fields. It finds the intersection (common fields) across all
%   and returns a single struct array containing only those common fields.
%
%   Usage:
%       combinedStruct = combineStructsByCommonFields(structCell);
%
%   Input:
%       structCell  - A cell array, where each cell contains a struct array
%                     (e.g., 1xN or Nx1). 
%
%   Output:
%       combinedStruct - A single struct array (1×M) containing only the 
%                        fields common to all input struct arrays.

    % If the cell array is empty, return an empty struct
    if isempty(structCell)
        combinedStruct = struct([]);
        return;
    end

    % 1) Collect the fieldnames from the first struct array
    commonFields = fieldnames(structCell{1});

    % 2) Intersect with fieldnames of subsequent struct arrays
    for i = 2:numel(structCell)
        currentFields = fieldnames(structCell{i});
        commonFields = intersect(commonFields, currentFields);
    end

    % 3) Remove any extra fields in each struct array
    for i = 1:numel(structCell)
        S = structCell{i};
        extraFields = setdiff(fieldnames(S), commonFields);
        if ~isempty(extraFields)
            S = rmfield(S, extraFields);
        end
        
        % No dimension reshape here; we keep S as it is
        structCell{i} = S;
    end

    % 4) Concatenate all struct arrays horizontally
    %    This results in a single row vector of structs: 1 x (N1 + N2 + ...)
    combinedStruct = [structCell{:}];
end
