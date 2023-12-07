function [figHandle,varargout] = fig_canvas(AxesNum,varargin)
    % Creat an empty figure handle with customized size and name
    % The size of the figure increases with AxesNum

    % unitSize: double element vector defining the size of minimum figure. 
    %   [width height] (normalized to the display).
    % AxesNum: the size of figure increases with AxesNum. 

    % example:
    %   [f,f_rowNum,f_colNum] = fig_canvas(16,'unit_width',0.2,'unit_height',0.3,...
        % 'row_lim',3,'column_lim',1);

    % Defaults
    unit_width = 0.2; % normalized the the size of display
    unit_height = 0.3; % normalized the the size of display
    max_width = 0.9;
    max_height = 0.9;
    pos_left = 0.05;
    pos_bottom = 0.01;


    % AxesNum does not have effect on figure size when it is bigger than the product of column_lim and row_lim
    % Recommendation: Use AxesNum <= column_lim*row_lim 
    column_lim = 4; 
    row_lim = 4; 

    fig_name = '';

    % debug_mode = false; % true/false

    % Options
    for ii = 1:2:(nargin-1)
        if strcmpi('unit_width', varargin{ii})
            unit_width = varargin{ii+1};
        elseif strcmpi('unit_height', varargin{ii})
            unit_height = varargin{ii+1};
        elseif strcmpi('pos_left', varargin{ii})
            pos_left = varargin{ii+1};
        elseif strcmpi('pos_bottom', varargin{ii})
            pos_bottom = varargin{ii+1};
        elseif strcmpi('column_lim', varargin{ii})
            column_lim = varargin{ii+1};
        elseif strcmpi('row_lim', varargin{ii})
            row_lim = varargin{ii+1};
        elseif strcmpi('fig_name', varargin{ii})
            fig_name = varargin{ii+1};
        elseif strcmpi('figHandle', varargin{ii})
            figHandle = varargin{ii+1};
        end
    end

    %% main contents
    if AxesNum <= column_lim
        fig_width = unit_width*AxesNum;
        col_num = AxesNum;
    else
        fig_width = unit_width*column_lim;
        col_num = column_lim;
    end
    if fig_width > max_width
        fig_width = max_width;
    end

    
    if AxesNum <= column_lim*row_lim
        fig_height = unit_height*ceil(AxesNum/column_lim);
        row_num = ceil(AxesNum/column_lim);
    else
        fig_height = unit_height*row_lim;
        row_num = row_lim;
    end
    if fig_height > max_height
        fig_height = max_height;
    end

    if exist('figHandle','var')  
        if ~isa(figHandle, 'matlab.ui.Figure')
            error('The varargin figHandle must be a handle of a figure')
        end
        figHandle;
    else
        figHandle = figure('Name', fig_name);
    end

    set(gcf,'Units','normalized',...
        'Position',[pos_left pos_bottom fig_width fig_height]);

    varargout{1} = row_num;
    varargout{2} = col_num;
end

