function [fitresult, gof] = ffExpFit(dataY, dataX)
%CREATEFIT1(DATA)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      Y Output: data
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 18-May-2019 20:22:42 自动生成


%% Fit: 'untitled fit 1'.
if nargin < 2 
    [xData, yData] = prepareCurveData( [], dataY );
else
    [xData, yData] = prepareCurveData( dataX, dataY );
end

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [10.4331526467243 -0.000720497376096412 110.294252636339 -5.07014187865602e-06];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'data', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% ylabel( 'data' );
% grid on


