function [new_struct] = empty_content_struct(field_names,entry_num,varargin)
    % Creat a structure var with empty content

    % default size is (entry_num, 1). Use varargin{3} (sizeDirection) to choose between vertical or
    % horizontal structure: [1] vertical as default: (entry_num, 1). [2] horizontal: (1, entry_num)

    % field_names: 'Char' or 'cell'. Name(s) of fields.
    % entry_num: Number of entries

    % example: create a length 5 structure with fields 'stim' and 'startTime'
        % fieldNames = {'stim','startTime'}
        % exampleStruct = empty_content_struct(fieldNames,5);

    if isa(field_names,'char')
        field_names = {field_names};
    end
    field_names = field_names(:).';

    if nargin == 2
        sizeDirection = 1;
    elseif nargin == 3
        sizeDirection = varargin{1};
    end


    if nargin == 1
        cellVar = field_names;
        cellVar{2,1} = {};
        new_struct = struct(cellVar{:});
    elseif nargin == 2 || nargin == 3
        if isempty(entry_num) || entry_num == 0
            cellVar = field_names;
            cellVar{2,1} = {};
            new_struct = struct(cellVar{:});
        else
            fn_num = numel(field_names);
            if sizeDirection == 1
                cellarray = cell(fn_num,entry_num);
            elseif sizeDirection == 2
                cellarray = cell(entry_num,fn_num);
            end
            new_struct = cell2struct(cellarray,field_names,sizeDirection);
        end
    end
end

