function [ PlotPlan ] = PlotLoad()
%PlotLoad loads and rescales a the plot for the current run.
%   Detailed explanation goes here
Plot_o = imread(uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' }));
waitfor(msgbox({'You''ll now be asked to select',' 2 points a known distance apart'}))
image(Plot_o)
XYs = ginput(2);
Dist = inputdlg('What is the distance between these points in feet?');
PlotPlan = imresize(Plot_o,str2num(Dist{1})/(pdist(XYs)));



end

