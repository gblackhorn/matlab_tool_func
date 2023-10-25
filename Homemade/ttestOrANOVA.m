function [statInfo,varargout] = ttestOrANOVA(dataCell,varargin)
    % two-sample ttest if there are two groups, one-way ANOVA with tuckey multiple comparison if
    % there are more groups

    % dataCell: cell array. 

    % groupNames: cell array. size of groupNames must be the same as violinData. One name for one 

    % default
    % statMethod = '';
    pairedData = false;


    % Optionals
    for ii = 1:2:(nargin-1)
        if strcmpi('groupNames', varargin{ii})
            groupNames = varargin{ii+1}; % struct var including fields 'cat_type', 'cat_names' and 'cat_merge'
        % elseif strcmpi('statMethod', varargin{ii})
        %     statMethod = varargin{ii+1}; % force the function to use a specific method
        elseif strcmpi('pairedData', varargin{ii})
            pairedData = varargin{ii+1};
        % elseif strcmpi('save_fig', varargin{ii})
        %     save_fig = varargin{ii+1};
        % elseif strcmpi('save_dir', varargin{ii})
        %     save_dir = varargin{ii+1};
        % elseif strcmpi('gui_save', varargin{ii})
        %     gui_save = varargin{ii+1};
        end
    end 

    groupNum = numel(dataCell);

    % verify groupNames. If it does not exist, create one
    if exist('groupNames','var')
        nameNum = numel(groupNames);

        if nameNum ~= groupNum 
            error('Inputs violinData and groupNames must have the same size')
        end
    else
        % create groupNames
        groupNames = cell(size(dataCell));
        for n = 1:groupNum
            groupNames{n} = sprintf('group%g',n);
        end
    end


    % run test for two or multiple groups
    if groupNum == 2 % two-sample ttest
        statInfo = empty_content_struct({'method','group1','group2','p','h'},1);

        % check normallity
        normDistrTF = true;
        for n = 1:groupNum
            % Run the Shapiro-Wilk parametric hypothesis test of composite normality to check the
            % normality of data
            [hVal_sw,pVal_sw] = swtest(dataCell{n});
            if hVal_sw == 1
                normDistrTF = false;
                break
            end
        end

        % mark data as 'unpaired' if the number of data points are different 
        if numel(dataCell(1)) ~= numel(dataCell(2))
            pairedData = false;
        end

        
        if normDistrTF 
            % run ttest 
            if pairedData 
                % paired data
                [hVal,pVal] = ttest(dataCell{1},dataCell{2});
            else
                % unpaired data
                [hVal,pVal] = ttest2(dataCell{1},dataCell{2});
            end
            % if ~pairedData
            %     [pVal,hVal] = unpaired_ttest_cellArray(dataCell(1),...
            %         dataCell(2));
            %     statInfo.method = 'two-sample ttest';
            % end
        else
            % run non-parametric test

        end


        statInfo.group1 = groupNames{1};
        statInfo.group2 = groupNames{2};
        statInfo.p = pVal;
        statInfo.h = hVal;

        % Create a table with variable names 'group1','group2','p' and 'h'
        % This can be plotted using plotUItable.m
        statTab = table(groupNames(1),groupNames(2),pVal,hVal,...
            'VariableNames',{'group1','group2','p', 'h'});
        statTitle = 'two-sample ttest';
    elseif numel(violinData) > 2 % one-way ANOVA with tucky multiple comparison
        % organize data for function 'prepareStructDataforAnova' to run one-way ANOVA
        dataVector = cell(groupNum,1);
        dataGroupCell = cell(groupNum,1);

        for n = 1:groupNum
            dataVector{n} = dataCell{n};
            dataVector{n} = reshape(dataVector{n},[],1);
            dataGroupCell{n} = repmat({groupNames{n}},numel(dataVector{n}),1);
        end
        dataVector = vertcat(dataVector{:});
        dataGroupCell = vertcat(dataGroupCell{:});


        % one-way anova with posthoc tuckey for multiple comparison
        [statInfo] = anova1_with_multiComp(dataVector,dataGroupCell);
        statTab = statInfo.c(:,["g1","g2","p","h"]);
        statTitle = 'one-way ANOVA [tuckey multiple comparison]'
    end

    varargout{1} = statTab;
    varargout{2} = statTitle;


end


