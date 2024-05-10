function newB = checkAndTranspose(A, B)
    % Check if A and B have the same number of entries. Tanspose B if the dimensions of A and B are
    % inverse


    if numel(A) == numel(B)
        % Get dimensions of A and B
        [rowsA, colsA] = size(A);
        [rowsB, colsB] = size(B);
        
        % Check if the dimensions are inverses of each other
        if rowsA == colsB && colsA == rowsB
            % Transpose B if the conditions are met
            newB = B';
            % disp('B has been transposed because its dimensions match the inverse of A.');
        elseif rowsA ~= rowsB && colsA ~= colsB
            error('the dimensions of A and B must be the same or reverse')
        elseif rowsA == rowsB && colsA == colsB
            newB = B;
        end
    else
        error('A and B do not have the same number of entries. No transpose operation performed.');
    end
end
