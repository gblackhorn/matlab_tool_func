function [yfit,varargout] = ExpDecayFitting(xdata,ydata,varargin)
	% Fit the data to a exponential decay curve
	% This function is modified from the matlab example CurveFittingViaOptimizationExample.mlx

	% Defaults
	PlotFit = false; % true/false. Plot the input data and the fitted data to examing the fitting

	% Define the objective function for fminsearch as a function of x alone
	% sse = sum(ydata-A*exp(-lambda*xdata)).^2);
	fun = @(x)sseval(x,xdata,ydata); % sseval: calculate the sum of squared errors with given A and lambda (x(1) and x(2)). 

	x0 = rand(2,1); % Start from a random positive set of parameters x0
	bestx = fminsearch(fun,x0); % have fminsearch find the parameters that minimize the objective function

	A = bestx(1);
	lambda = bestx(2);
	yfit = A*exp(-lambda*tdata); % the fitted data

	% A and lambda are used to define the expoential decay curve y(x) = A*exp(-lambda*x)
	varargout{1}.A = A;
	varargout{1}.lambda = lambda;

	if PlotFit
		f_title = 'data and fitting to exponential decay';
		f_fit = figure(1,'unit_height',0.2,'fig_name',f_title);
		plot(xdata,ydata,'*');
		hold on
		plot(xdata,yfit,'r');
		xlabel('xdata')
		ylabel('Response Data and Curve')
		title(f_title)
		legend('data','fitted curve')
		hold off
	end
end