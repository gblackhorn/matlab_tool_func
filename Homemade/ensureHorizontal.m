function arrayData = ensureHorizontal(arrayData)
    % Check if the cell array is not horizontal
    if size(arrayData, 1) > 1 && size(arrayData, 2) == 1
        % Transpose it to make it horizontal
        arrayData = arrayData.';
    end
end
