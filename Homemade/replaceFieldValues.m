function updatedStruct = replaceFieldValues(structVar, fieldName, replacementCell)
    % replaceFieldValues replaces the values in a specified field with corresponding values from a cell array
    % structVar: The structure array containing the field to be modified
    % fieldName: The name of the field to be modified (as a string)
    % replacementCell: A cell array containing the new values (must be in the form of a two-column cell array: {oldValue, newValue})
    
    % Convert the fieldName to a string if it is not already
    fieldName = string(fieldName);
    
    % Get the field data
    fieldData = {structVar.(fieldName)};
    
    % Initialize the updated field data
    updatedFieldData = fieldData;
    
    % Replace values based on the replacementCell mapping
    for i = 1:size(replacementCell, 1)
        oldValue = replacementCell{i, 1};
        newValue = replacementCell{i, 2};
        
        % Find indices where the field data matches the old value
        if isnumeric(oldValue)
            indices = cellfun(@(x) isequal(x, oldValue), fieldData);
        else
            indices = strcmp(fieldData, oldValue);
        end
        
        % Replace these indices with the new value
        updatedFieldData(indices) = {newValue};
    end
    
    % Update the structure array with the new field data
    for i = 1:numel(structVar)
        structVar(i).(fieldName) = updatedFieldData{i};
    end
    
    % Return the updated structure
    updatedStruct = structVar;
end
