function combinedTable = combineTabsWithSameRowTitle(tabA, tabB)
	% Combine tabA and tabB horizontally

	% This function will compare the row titles (first column of a tab) between tabA and tabB, and
	% combine rows sharing the same titles. Row titles in tabB will be deleted in the combinedTable

	% Step 1: Extract the first columns (matching key) from both tables
	keyTabA = tabA{:, 1};  % First column from tabA
	keyTabB = tabB{:, 1};  % First column from tabB

	% Step 2: Find the common keys and their corresponding indices in both tables
	[commonKeys, idxA, idxB] = intersect(keyTabA, keyTabB, 'stable');

	% Step 3: Extract the matched rows from both tables
	matchedTabA = tabA(idxA, :);
	matchedTabB = tabB(idxB, :);

	% Step 4: Remove the first column from tabB (since it's the matching key)
	matchedTabB(:, 1) = [];  % Remove the first column

	% Step 5: Concatenate the tables horizontally
	combinedTable = [matchedTabA, matchedTabB];

	% % Display the combined table
	% disp(combinedTable);
end
