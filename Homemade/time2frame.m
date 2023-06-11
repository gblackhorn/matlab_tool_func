function [framesOfTimeStamps,varargout] = time2frame(timeStamps,FrameTimes,varargin)
    % given 'timeStamps', an array of times, and the 'FrameTimes', a series of time for all frames,
    % return the 'framesOfTimeStamps', the frames (index) of timeStamps in FrameTimes


    % % Defaults
    % colorLUT = 'turbo'; % default look up table (LUT)/colormap. Other sets are: 'parula','hot','jet', etc.
    % show_colorbar = true; % true/false. Show color next to the plot if true.
    % xtickInt = 10; % interval between x ticks
    % breakerLine = NaN; % Input a row index. below this row, a horizontal line will be draw to seperate the heatmap

    % % Optionals for inputs
    % for ii = 1:2:(nargin-2)
    %     if strcmpi('rowNames', varargin{ii})
    %         rowNames = varargin{ii+1}; % cell array containing strings used to label y_ticks
    %     elseif strcmpi('x_window', varargin{ii})
    %         x_window = varargin{ii+1}; % [a b] numerical array. Used to display time
    %     elseif strcmpi('xtickInt', varargin{ii})
    %         xtickInt = varargin{ii+1}; % a single number to set the interval between x ticks
    %     % elseif strcmpi('x_rescale', varargin{ii})
    %     %     x_rescale = varargin{ii+1}; % a single number to set the interval between x ticks
    %     elseif strcmpi('breakerLine', varargin{ii})
    %         breakerLine = varargin{ii+1}; % 
    %     elseif strcmpi('colorLUT', varargin{ii})
    %         colorLUT = varargin{ii+1}; % look up table (LUT)/colormap: 'turbo','parula','hot','jet', etc.
    %     elseif strcmpi('show_colorbar', varargin{ii})
    %         show_colorbar = varargin{ii+1}; % look up table (LUT)/colormap: 'turbo','parula','hot','jet', etc.
    %     end
    % end

    % Convert the timeStamps to a column vector
    timeStamps = reshape(timeStamps,[],1);

    % Create framesOfTimeStamps and fill it with NaNs
    framesOfTimeStamps = NaN(size(timeStamps));

    % Look for every 'timeStamps' in the 'FrameTimes'
    stampsNum = numel(timeStamps);
    if stampsNum > 0
        for n = 1:stampsNum
            stampFrame = find(FrameTimes==timeStamps(n));
            if ~isempty(stampFrame)
                framesOfTimeStamps(n) = stampFrame;
            else
                warning('timeStamps not found in FrameTimes')
            end
        end
    end
end
