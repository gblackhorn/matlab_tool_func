function updatedStruct = replaceFieldWithArray(S, fieldName, replacementArray)
    % replaceFieldWithArray replaces the values in a specified field with values from a replacement array
    % S: The structure array containing the field to be modified
    % fieldName: The name of the field to be modified (as a string)
    % replacementArray: The array containing the new values (must have the same length as S)
    
    % Ensure the length of replacementArray matches the length of the structure array S
    if length(S) ~= length(replacementArray)
        error('The length of the replacement array must match the length of the structure array.');
    end
    
    % Convert the fieldName to a string if it is not already
    fieldName = string(fieldName);
    
    % Determine the type of data in the replacement array
    if isnumeric(replacementArray)
        replacementCell = num2cell(replacementArray);
    elseif iscell(replacementArray)
        replacementCell = replacementArray;
    elseif ischar(replacementArray) || isstring(replacementArray)
        replacementCell = cellstr(replacementArray);
    else
        error('Unsupported data type for replacement array.');
    end
    
    % Use deal to distribute the cell array elements to the structure field
    [S.(fieldName)] = deal(replacementCell{:});
    
    % Return the updated structure
    updatedStruct = S;
end
