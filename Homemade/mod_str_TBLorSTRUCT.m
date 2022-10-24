function [newTBLorSTRUCT,varargout] = mod_str_TBLorSTRUCT(TBLorSTRUCT,VARorFIELD,OldPat,NewPat,varargin)
	%Replace the old char patterns with the new patterns in a specified variable(tbl)/field(structure) 

	% newTBLorSTRUCT = mod_CellStr(TBLorSTRUCT,VARorFIELD,OldPat,NewPat) update the char in a specified
	% variable(tbl)/field(structure) by replacing the OldPat with the NewPat. 

	%	TBLorSTRUCT: A table or structure var containing character viarable(tbl)/field(struct). 
	%	OldPat: A cell array containing old patterns. For example: {{'OG-LED'}, {'AP','AP_GPIO-1'}}
	%	NewPat: A cell array containing new patterns. size of NewPat must be equal to the size of OldPat. For example: {'og', 'ap'}
	%
	% Example:
	%	TBLorSTRUCT.stim = {'OG-LED-5s','AP_GPIO-1-0.1s','AP-0.1s','OG-LED-5s AP_GPIO-1-1s','OG-LED-5s AP-1s'}
	%	OldPat = {{'OG-LED'}, {'AP','AP_GPIO-1'}}
	%	NewPat = {'og', 'ap'}
	%	new_stim_names = mod_CellStr(TBLorSTRUCT.stim,OldPat,NewPat)
 
 	% Get the character cells from table or structure by specifying the variable(tbl) or field
	if istable(TBLorSTRUCT)
		CellStr = TBLorSTRUCT.(VARorFIELD);
		var_type = 1;
	else
		CellStr = {TBLorSTRUCT.(VARorFIELD)};
		var_type = 2;
	end

	newCellStr = mod_CellStr(CellStr,OldPat,NewPat);

	newTBLorSTRUCT = TBLorSTRUCT;
	if var_type == 1 % table
		newTBLorSTRUCT.(VARorFIELD) = newCellStr;
	elseif var_type == 2 % structure
		[newTBLorSTRUCT.(VARorFIELD)] = newCellStr{:};
	end
end
