function isNumOrLogical = isCellArrayNumericOrLogical(cellArray)
% ISCELLARRAYNUMERICORLOGICAL Check if a cell array contains only numeric or logical elements.
%
% This function verifies whether all elements within a given cell array are either numeric or logical.
% This validation is important when you plan to convert a cell array to a MATLAB array using the `cell2mat`
% function, as `cell2mat` requires all elements to be compatible types.
%
% INPUT:
%   cellArray - A cell array containing elements that need to be checked for compatibility with `cell2mat`.
%
% OUTPUT:
%   isNumOrLogical - A logical value:
%       - true if all elements in the cell array are numeric or logical.
%       - false if any element is not numeric or logical.
%
% USAGE:
%   isNumOrLogical = isCellArrayNumericOrLogical(cellArray)
%
% Example:
%   cellArray = {1, 2, 3; 4, 5, 6};
%   isNumOrLogical = isCellArrayNumericOrLogical(cellArray);
%   % isNumOrLogical should return true, meaning `cell2mat(cellArray)` can be safely used.
%
%   cellArray = {1, 2, '3'; 4, 5, 6};
%   isNumOrLogical = isCellArrayNumericOrLogical(cellArray);
%   % isNumOrLogical should return false, indicating `cell2mat(cellArray)` will fail.

% Check if the input is a cell array
if ~iscell(cellArray)
    error('Input must be a cell array.');
end

% Initialize the output as true
isNumOrLogical = true;

% Iterate over each element in the cell array
for i = 1:numel(cellArray)
    if ~isnumeric(cellArray{i}) && ~islogical(cellArray{i})
        isNumOrLogical = false;
        break;
    end
end
end
