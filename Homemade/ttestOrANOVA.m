function [statInfo,varargout] = ttestOrANOVA(dataCells,varargin)
	% run two-sample ttest or one-way ANOVA 

	% Wher 

	% dataCells: cell array. Run ttest if there are two cells. Run ANOVA if there are more than two cells

	% [violinInfo(rn).stat,violinInfo(rn).statTab] = ttestOrANOVA(violinData,'groupNames',groupNames(rn,:));

	% Defaults

	% Optionals
	for ii = 1:2:(nargin-1)
	    if strcmpi('groupNames', varargin{ii})
	        groupNames = varargin{ii+1}; % struct var including fields 'cat_type', 'cat_names' and 'cat_merge'
	    % elseif strcmpi('postStimDuration', varargin{ii})
	    %     postStimDuration = varargin{ii+1}; 
	    % elseif strcmpi('plot_raw_races', varargin{ii})
	    %     plot_raw_races = varargin{ii+1}; % struct var including fields 'cat_type', 'cat_names' and 'cat_merge'
        % elseif strcmpi('eventCat', varargin{ii})
	    %     eventCat = varargin{ii+1};
        % elseif strcmpi('fname', varargin{ii})
	    %     fname = varargin{ii+1};
	    end
	end

	% get the number of cells in 'dataCells'
	dataCellNum = numel(dataCells);


	% verify the groupNames if it exists. Create them if it does not exist
	if exist('groupNames','var')
		if numel(groupNames) ~= numel(dataCells)
			error('numbers of groupNames must the same as dataCells')
		end
	else
		groupNames = cell(size(dataCells));
		for n = 1:dataCellNum
			groupNames{n} = sprintf('group%g',n);
		end
	end


	% run stat
	if dataCellNum == 2 % two-sample ttest
		statInfo = empty_content_struct({'method','group1','group2','h','p','ci','stats'});

		statInfo.method = 'two-sample ttest';
		statInfo.group1 = groupNames{1};
		statInfo.group2 = groupNames{2};

		% ttest
		[statInfo.h,statInfo.p,statInfo.ci,statInfo.stats] = ttest2(dataA, dataB);

		% create a table which can be plotted using plotUItable
		statTab = table(statInfo.method,statInfo.group1,statInfo.group2,statInfo.h,statInfo.p);
		statTab.Properties.VariableNames = {'method','group1','group2','h','p'};

	elseif dataCellNum > 2 % one-way ANOVA
		statInfo = empty_content_struct({'method','p','tbl','stats','multiComp'});

		statInfo.method = 'one-way ANOVA';

		% reshape the data in each cell
		dataCells = cellfun(@(x),reshape(x,[],1),dataCells,'UniformOutput',false);

		% combine all the cell
		dataVector = vertcat(dataCells);

		% prepare the labels for dataVector
		groupLabels = repelem(groupNames, cellfun('size', dataCells, 1));

		% ANOVA
		[statInfo] = anova1_with_multiComp(dataVector,groupLabels);

		statTab = statInfo.c(:,["g1","g2","p","h"]);

		% [statInfo.p, statInfo.tbl, statInfo.stats] = anova1(dataVector, groupLabels);
	end

	varargout{1} = statTab;

	
end

