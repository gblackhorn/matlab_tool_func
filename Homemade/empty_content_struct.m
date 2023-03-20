function [new_struct] = empty_content_struct(field_names,entry_num,varargin)
    % Creat a structure var with empty content

    % default size is (entry_num, 1). Use varargin{3} (sizeDirection) to decide if the keep the
    % default (1) or use (1, entry_num) with 2 as input

    % field_names: 'Char' or 'cell'. Name(s) of fields.
    % entry_num: Number of entries

    if isa(field_names,'char')
        field_names = {field_names};
    end
    field_names = field_names(:).';

    if nargin == 2
        sizeDirection = 1;
    elseif nargin == 3
        sizeDirection = varargin{3};
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
            new_struct = cell2struct(cellarray,field_names);
        end
    end
end

