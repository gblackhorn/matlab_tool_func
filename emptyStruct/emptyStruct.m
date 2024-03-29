function structure = emptyStruct(fieldnames, sz)
%emptyStruct makes an empty structure array of various sorts
%   structure = EMPTYSTRUCT(FIELDNAMES), where FIELDNAMES is a cell array of
%   strings, returns a 0x0 struct array with the given fields.
%
%   structure = EMPTYSTRUCT(SZ), where SZ is a numeric scalar or vector, returns
%   a struct array with no fields. If SZ is empty an 0-by-0 array is
%   returned; if SZ is a scalar N an N-by-N array is returned; if SZ is a
%   vector [M, N, ...] an M-by-N-by-... array is returned.
%
%   structure = EMPTYSTRUCT(FIELDNAMES, SZ) returns a struct with the given
%   fields and the given size, each of whose elements is the empty matrix.
% 
% Note that ISEMPTY(structure) only returns true in the first of these cases, or
% if the SZ argument specifies an empty array.
% 
% Examples:
%
%   s1 = emptyStruct({'foo' 'baz'});
%   s2 = emptyStruct([3, 2]);
%   s3 = emptyStruct({'foo' 'baz'}, [3, 2]);
% 
% See also: struct, isempty, zeros

if nargin == 1
    
    if isempty(fieldnames)
        structure = struct([]);
    elseif iscellstr(fieldnames)
        strargs = fieldnames(:).';
        strargs{2, 1} = {};     % sets size for whole struct
        structure = struct(strargs{:});
    else    % fieldnames actually a size vector
        structure = repmat(struct, fieldnames);
    end
    
else            % nargin = 2
    
    if isempty(fieldnames)
        structure = emptyStruct(sz);
    elseif isempty(sz)
        structure = emptyStruct(fieldnames);
    else
        strargs = fieldnames(:).';
        strargs{2, 1} = cell(sz);  % sets size for whole struct
        structure = struct(strargs{:});
    end
    
end

end

