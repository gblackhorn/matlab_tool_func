function [newCellStr,varargout] = mod_CellStr(CellStr,OldPat,NewPat,varargin)
	%Replace the old patterns in CellStr with the new patterns

	% newCellStr = mod_CellStr(CellStr,OldPat,NewPat) update the CellStr by
	% replacing the OldPat with the NewPat. 
	%	CellStr: A cell array containing characters in each cell. 
	%	OldPat: A cell array containing old patterns. For example: {{'OG-LED'}, {'AP','AP_GPIO-1'}}
	%	NewPat: A cell array containing new patterns. size of NewPat must be equal to the size of OldPat. For example: {'og', 'ap'}
	%
	% Example:
	%	stim_names = {'OG-LED-5s','AP_GPIO-1-0.1s','AP-0.1s','OG-LED-5s AP_GPIO-1-1s','OG-LED-5s AP-1s'}
	%	OldPat = {{'OG-LED'}, {'AP','AP_GPIO-1'}}
	%	NewPat = {'og', 'ap'}
	%	new_stim_names = mod_CellStr(stim_names,OldPat,NewPat)
 

	num_OldPat = numel(OldPat);
	num_NewPat = numel(NewPat);
	if num_OldPat ~= num_NewPat
		error('Function mod_CellStr: Old patterns and new patterns must have the same size.')
	end

	newCellStr = CellStr;
	for n = 1:num_OldPat
		newCellStr = replace(newCellStr,OldPat{n},NewPat{n});
	end
end
