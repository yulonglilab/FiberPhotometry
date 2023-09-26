clearvars -except newpath;
[filename, pathname]=getlastfile('*.mat','Load file',0);
if pathname==0
    return;
end
load([pathname,filename]);


%  
% 


