function [firstClosestIDX,varargout] = getFirstClosest_multiWin(fullArray,idealValues,bigOrSmall,winRange,varargin)
    % find locations of first points close to the given values (ideal_value) in every
    % window in fullArray
    %   fullArray: find ideal values in this array
    %   idealValues: a single column array of numbers
    %   bigOrSmall: If 'big', find fullArray value >= idealValues. If 'small', find fullArray value <= idealValues
    %   winRange: 2-column array. IDX of start and end points for finding idealValues in fullArray. 
    %       Has the same number of rows like ideal_value

    maxRange = [];
    % Optionals for inputs
    for ii = 1:2:(nargin-4)
        if strcmpi('maxRange', varargin{ii})
            maxRange = varargin{ii+1};
        % elseif strcmpi('sz', varargin{ii})
        %   sz = varargin{ii+1};
        end
    end


    % modify the winRange if maxRange is not empty
    if ~isempty(maxRange)
        modWinEnd = winRange(:,1)+maxRange-1;
        % modIDX = logical(zeros(size(winRange(:,1))));
        for n = 1:numel(modWinEnd)
            % currentRange = winRange(n,2)-winRange(n,1)+1;
            if winRange(n,2) > modWinEnd(n)
                winRange(n,2) = modWinEnd(n);
            end
        end
    end


    firstClosestIDX = NaN(size(idealValues));
    for n = 1:length(idealValues)
        switch bigOrSmall
            case 'big'
                firstValIDX = find(fullArray(winRange(n,1):winRange(n,2))>=idealValues(n),1);
            case 'small'
                firstValIDX = find(fullArray(winRange(n,1):winRange(n,2))<=idealValues(n),1);
            otherwise
                error('input for bigOrSmall must be either big or small')
        end

        % assign NaN if firstValIDX is empty
        if isempty(firstValIDX)
            firstValIDX = NaN;
        end
        
        % firstValIDX = find(fullArray(winRange(n,1):winRange(n,2))>=idealValues(n),1);

        % [diff_value, loc_in_window] = min(abs(roi_trace(window_range(n, 1):window_range(n, 2))-idealValues(n)));
        firstClosestIDX(n) = winRange(n, 1)-1+firstValIDX;
    end
end

