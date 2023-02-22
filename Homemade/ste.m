function [data_ste,varargout] = ste(data,varargin)
	% Calculate the stdandard error (ste)
	% This function only calculate the ste of all numbers in ste, row and column numbers are not considered
	% ste= std( data ) / sqrt( length( data ))

	omitnan = true; % true/false. If true, omit nan elements in the array

	% Optionals
	for ii = 1:2:(nargin-1)
	    if strcmpi('omitnan', varargin{ii})
	        omitnan = varargin{ii+1};
	    % elseif strcmpi('guiInfo', varargin{ii}) % trace mean value comparison (stim vs non stim). output of stim_effect_compare_trace_mean_alltrial
	    %     guiInfo = varargin{ii+1}; % output of stim_effect_compare_trace_mean_alltrial
	    % elseif strcmpi('guiSave', varargin{ii})
        %     guiSave = varargin{ii+1};
	    % elseif strcmpi('fname', varargin{ii})
        %     fname = varargin{ii+1};
	    end
	end

	% ====================
	% Main contents

	if omitnan
		data = data(~isnan(data));
	end

	data_ste = std(data,'includenan')/sqrt(length(data));
end