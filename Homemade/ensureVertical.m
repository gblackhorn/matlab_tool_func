function arrayData = ensureVertical(arrayData)
    % ENSUREVERTICAL Ensures that the input array is vertical.
    %   arrayData = ensureVertical(arrayData) checks if the input array is
    %   horizontal. If it is, the function transposes it to make it vertical.

    % Check if the array is horizontal
    if size(arrayData, 1) == 1 && size(arrayData, 2) > 1
        % Transpose it to make it vertical
        arrayData = arrayData.';
    end
end
