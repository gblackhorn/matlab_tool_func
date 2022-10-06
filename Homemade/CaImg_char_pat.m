function [char_OldNew_pat,varargout] = CaImg_char_pat(char_category,varargin)
    %Return old and new charater patterns for modifying characters in calcium imaging analysis

    % char_OldNew_pat = caImg_char_pat(char_category) return the different patterns of characters
    %   char_category: options are 'stimulation', 'event_group'

    % Example:
    %   char_category = 'stimulation'
    %   char_OldNew_pat = caImg_char_pat(char_category)


    %% main contents
    switch CatType
    case 'stimulation'
        % char_OldNew_pat.cat_type = 'stim_name';
        % char_OldNew_pat.cat_names = {'og', 'ap'};
        % char_OldNew_pat.cat_merge = {{'OG-LED'}, {'AP_GPIO-1','AP'}};

        % char_OldNew_pat.cat_type = 'stim_name';
        char_OldNew_pat.new = {'og', 'ap'};
        char_OldNew_pat.old = {{'OG-LED'}, {'AP','AP_GPIO-1'}};
    case 'event'
        % char_OldNew_pat.cat_type = 'peak_category'; % 'fovID', 'peak_category'
        char_OldNew_pat.new = {'spon', 'trig', 'trig-AP', 'opto-delay', 'rebound'}; % new category names
        cat_num = numel(char_OldNew_pat.new);
        char_OldNew_pat.old = cell(cat_num, 1); % each cell contains old categories which will be grouped together
        char_OldNew_pat.old{1} = {'noStim', 'beforeStim', 'interval',...
            'beforeStim-beforeStim', 'interval-interval'}; % spon
        char_OldNew_pat.old{2} = {'trigger', 'trigger-beforeStim', 'trigger-interval'}; % trig
        char_OldNew_pat.old{3} = {'delay-trigger'}; % trig-AP
        char_OldNew_pat.old{4} = {'delay', 'delay-rebound', 'delay-interval', 'delay-beforeStim'}; % delay. 'delay-delay', 
        char_OldNew_pat.old{5} = {'rebound', 'rebound-interval'}; % rebound
    end
end

