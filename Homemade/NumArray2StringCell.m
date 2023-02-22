function [StringCell,varargout] = NumArray2StringCell(varargin)
    % Return a cell containing strings.
    % The StringCell is a 1*n cell array

    % Example:

    %   [StringCell] = NumArray2StringCell(n) create a cell with n elements. If 3 is inputted
    % as n, StringCell will be {'1','2','3'}

    %   [StringCell] = NumArray2StringCell(n,FirstNum) create a cell with n elements starting
    %   from 'FirstNum'. If n==3, FirstNum==4, StringCell will be {'4','5','6'}

    %   [StringCell] = NumArray2StringCell(ArrayData) creat a cell using the numbers in the
    %   arrayData. if ArrayData == [1 3 6], StringCell will be {'1','3','6'}


    if numel(varargin{1})==1 % if the first input is a single number
        str_num = varargin{1}; % the total element number of the output, StringCell 
        if nargin==1
            FirstNum = 1; % string starts from 1
        elseif nargin==2 % if there are 2 input
            FirstNum = varargin{2}; % string start from the 2nd input
        end 
        LastNum = FirstNum+str_num-1;
        NumArray = [FirstNum:1:LastNum];
        StringCell = arrayfun(@num2str,NumArray,'UniformOutput',0);
    elseif numel(varargin{1})>1 % if the first input is an array, i.e., there are multiple numbers in it.
        StringCell = arrayfun(@num2str,varargin{1},'UniformOutput',0); % convert the inputted number array to strings in cell directly
    end
end