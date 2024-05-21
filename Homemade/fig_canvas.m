function [figHandle,varargout] = fig_canvas(AxesNum,varargin)
    % Creat an empty figure handle with customized size and name
    % The size of the figure increases with AxesNum

    % unitSize: double element vector defining the size of minimum figure. 
    %   [width height] (normalized to the display).
    % AxesNum: the size of figure increases with AxesNum. 

    % example:
    %   [f,f_rowNum,f_colNum] = fig_canvas(16,'unit_width',0.2,'unit_height',0.3,...
        % 'row_lim',3,'column_lim',1);


    % Define default values
    defaults = struct(...
        'unit_width', 0.2, ...
        'unit_height', 0.3, ...
        'max_width', 0.9, ...
        'max_height', 0.9, ...
        'pos_left', 0.05, ...
        'pos_bottom', 0.01, ...
        'column_lim', 4, ...
        'row_lim', 4, ...
        'fig_name', '', ...
        'figHandle', [] ...
    );

    % Create an inputParser object
    p = inputParser;

    % Define optional parameters and their default values
    addParameter(p, 'unit_width', defaults.unit_width);
    addParameter(p, 'unit_height', defaults.unit_height);
    addParameter(p, 'max_width', defaults.max_width);
    addParameter(p, 'max_height', defaults.max_height);
    addParameter(p, 'pos_left', defaults.pos_left);
    addParameter(p, 'pos_bottom', defaults.pos_bottom);
    addParameter(p, 'column_lim', defaults.column_lim);
    addParameter(p, 'row_lim', defaults.row_lim);
    addParameter(p, 'fig_name', defaults.fig_name);
    addParameter(p, 'figHandle', defaults.figHandle);

    % Parse the input arguments
    parse(p, varargin{:});

    % Access the parsed results
    unit_width = p.Results.unit_width;
    unit_height = p.Results.unit_height;
    max_width = p.Results.max_width;
    max_height = p.Results.max_height;
    pos_left = p.Results.pos_left;
    pos_bottom = p.Results.pos_bottom;
    column_lim = p.Results.column_lim;
    row_lim = p.Results.row_lim;
    fig_name = p.Results.fig_name;
    figHandle = p.Results.figHandle;



    % Validate figHandle and create a new figure if necessary
    if isempty(figHandle)
        figHandle = figure('Name', fig_name);
    elseif ~ishghandle(figHandle, 'figure')
        error('The varargin figHandle must be a handle of a figure');
    end

    % Use the default values and inputs to decide the size of the figure
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


    % Adjust the figure size
    set(gcf,'Units','normalized',...
        'Position',[pos_left pos_bottom fig_width fig_height]);

    varargout{1} = row_num;
    varargout{2} = col_num;
end

