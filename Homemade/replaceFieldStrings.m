function structVar = replaceFieldStrings(structVar, fieldName, A, B, caseSensitive, exactMatch)
%REPLACEFIELDSTRINGS Replace specific strings in a structure field
%
%   structVar = replaceFieldStrings(structVar, fieldName, A, B, caseSensitive, exactMatch)
%
% Inputs:
%   structVar     - Structure array containing multiple entries.
%   fieldName     - String specifying the field name to be modified.
%   A             - Cell array of strings to search for.
%   B             - Cell array of strings to replace with (same length as A).
%   caseSensitive - Logical flag: true for case-sensitive replacement,
%                   false for case-insensitive.
%   exactMatch    - Logical flag: true for exact match replacement,
%                   false for pattern/substring matching.
%
% Outputs:
%   structVar - Updated structure array with replaced strings in the specified field.

    % Input validation
    if ~isstruct(structVar)
        error('Input structVar must be a structure array.');
    end
    if ~isfield(structVar, fieldName)
        error('The specified field "%s" does not exist in the structure.', fieldName);
    end
    if ~iscell(A) || ~iscell(B) || length(A) ~= length(B)
        error('Inputs A and B must be cell arrays of the same length.');
    end
    if nargin < 6
        error('All six inputs, including exactMatch, must be provided.');
    end

    % Loop through all entries in the structure
    for i = 1:numel(structVar)
        % Extract current field content
        currentStr = structVar(i).(fieldName);
        
        % Check if current field is a string/char
        if ~ischar(currentStr) && ~isstring(currentStr)
            continue; % Skip non-string fields
        end
        
        % Perform search and replace
        for j = 1:length(A)
            searchStr = A{j};
            replaceStr = B{j};
            
            % Case-sensitivity control
            ignoreCaseOption = ~caseSensitive;

            if exactMatch
                % Exact match replacement
                if (caseSensitive && strcmp(currentStr, searchStr)) || ...
                   (~caseSensitive && strcmpi(currentStr, searchStr))
                    currentStr = replaceStr;
                end
            else
                % Substring replacement using contains
                if contains(currentStr, searchStr, 'IgnoreCase', ignoreCaseOption)
                    currentStr = strrep(currentStr, searchStr, replaceStr);
                end
            end
        end
        
        % Update the structure field
        structVar(i).(fieldName) = currentStr;
    end
end
