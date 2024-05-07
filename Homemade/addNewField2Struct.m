function newStructVar = addNewField2Struct(structVar,newFieldName,newFieldContent)
    % Add a new field to an existing structure variable

    % structVar: a existing structure variable

    % newFieldName: a string var, such as 'newFieldName'

    % newFieldContent: content used to fill the new field. If the size is 1*1, all entries of the
    % new field will contain the same content. If the length of it is the same as the structVar,
    % assign the content to every entry (must be a cell array)


    newStructVar = structVar;

    % Check the size of structVar and newFieldContent
    if numel(newFieldContent) ~= 1
        % Ensure structVar and newFieldContent have the same size
        newFieldContent = checkAndTranspose(structVar,newFieldContent);

        % Add the new field
        [newStructVar.(newFieldName)] = newFieldContent{:};
    else
        newFieldContentCell = cell(size(structVar));
        [newFieldContentCell{:}] = deal(newFieldContent);
        [newStructVar.(newFieldName)] = newFieldContentCell{:};
    end
end
