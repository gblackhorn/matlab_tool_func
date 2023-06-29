function [newStruct,varargout] = combineStuctFields(struct1,struct2,varargin)
	% combine 2 struct vars having the same size but various fields

	% add the fields from struct2 to stuct1

	% struct1 and struct2 must be 1*n or n*1 structures


	% Defaults
	overwrite = false; % If true, when struct1 and struct2 share the same fieldnames, use struct2 data

	% Optionals
	for ii = 1:2:(nargin-2)
	    if strcmpi('overwrite', varargin{ii})
	        overwrite = varargin{ii+1}; % struct var including fields 'cat_type', 'cat_names' and 'cat_merge'
	    % elseif strcmpi('eventTimeType', varargin{ii})
	    %     eventTimeType = varargin{ii+1}; 
	    end
	end

	% create newStruct and assign struct1 to it
	newStruct = struct1;

	% check if struct1 and struct2 have the same size
	[rStruct1, cStruct1] = size(struct1);
	[rStruct2, cnStruct2] = size(struct2);
	if rStruct1~=rStruct2 || cStruct1~=cnStruct2
		error('sizes of input structur vars must be the same')
	end

	% get the field names of struct1 and struct2
	fieldsS1 = fieldnames(struct1);
	fieldsS2 = fieldnames(struct2);

	% find the intersection of the fieldnames
	[commonF,i1,i2] = intersect(fieldsS1,fieldsS2);


	% add fields from struct2 to struct1 one by one
	for n = 1:numel(fieldsS2)
		field = fieldsS2{n}; % name of a field from struct2
		fieldContent = {struct2.(field)};

		% if field is not found in the commonF
		if isempty(find(strcmpi(commonF,field)));
			[newStruct.(field)] = struct2(:).(field);

			% if field is found in both struct1 and struct2 
		else
			% if overwrite, replace the field content of struc1 with the struct2's
			if overwrite
				[newStruct.(field)] = struct2(:).(field);
			end
		end
	end

end