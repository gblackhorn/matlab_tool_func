function [binaryVector,varargout] = time2binary(timePoints,maxTime,binSize,varargin)
	% Convert time points (unit: seconds) to binary vector (vertical)

	% Example:
	%		

	% Defaults
	% stim_names = {'og-5s','ap-0.1s','og-5s ap-0.1s'}; % compare the alignedData.stim_name with these strings and decide what filter to use
	% filters = {[nan 1 nan nan], [1 nan nan nan], [nan nan nan nan]}; % [ex in rb exApOg]. ex: excitation. in: inhibition. rb: rebound. exApOg: excitatory AP during OG
		% filter number must be equal to stim_names

	% % Optionals
	% for ii = 1:2:(nargin-1)
	%     if strcmpi('stim_names', varargin{ii}) % trace mean value comparison (stim vs non stim). output of stim_effect_compare_trace_mean_alltrial
	%         stim_names = varargin{ii+1}; % normalize every FluoroData trace with its max value
	%     elseif strcmpi('filters', varargin{ii})
    %         filters = varargin{ii+1};
	%     end
	% end


	% Get the number of timePoints
	timePointsNum = numel(timePoints);

	% Initialize binary vector
	binaryVector = zeros(ceil(maxTime/binSize),1);

	% Get the index timePoints in the binaryVector
	timePointsIDX = ceil(timePoints/binSize);

	% Fill in binaryVector
	binaryVector(timePointsIDX) = 1;

	% Output the number of timePoints as a varargout
	varargout{1} = timePointsNum;
end