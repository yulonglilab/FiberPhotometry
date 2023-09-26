function [peaks,locs]= findPeaksInTrace(y,ismax,isplot)
% y is input data, and y should be a vector
% ismax=1 时返回最大的peak,否则返回所有peak
% isplot=1是画出图
% peaks is the peak value in y
% locs is the index of peaks in y
if nargin<1
    error('no data');
end


if nargin<2
    ismax=0;
end
if nargin<3
    isplot=0;
end

if ~isvector(y)
        error('bad input,y must is vector');
end

if size(y,1)>1
    y=y';
end
y_flip=fliplr(y);
y_left=y_flip;
y_right=y_flip;

y_left(end)=[];
y_right(1)=[];
y_new=[y_left,y,y_right];

[~,locs]=findpeaks(y_new);
locs=locs(find(locs>length(y_left)&locs<=(length(y_left)+length(y))));
locs=locs-length(y_left);
peaks=y(locs);

if ismax
    [peaks,locsind]=max(peaks);
    locs=locs(locsind);
end
if isplot    
    figure('name','findPeaks')    
    plot(y,'color',[0.5,0.5,0.5]);    
    hold on;    
    plot(locs,peaks,'Marker','o','MarkerEdgeColor','r','MarkerSize',13);    
    hold off;
    
end
end