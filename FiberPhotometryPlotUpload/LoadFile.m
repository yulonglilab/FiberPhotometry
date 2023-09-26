clearvars -except newpath;
[filename, pathname]=getlastfile('*.csv','Load event file',0);
if pathname==0
    return;
end
% load([pathname,filename]);
k_time=1000000000;
eventtime=xlsread([pathname,filename]);
[filename, pathname]=getlastfile('*.csv','Load signal file',0);
if pathname==0
    return;
end
signal_ori=xlsread([pathname,filename]);
ff475=signal_ori(:,2);
camera_clock=signal_ori(:,3);
camera_clock_interval=diff(camera_clock);
for i=1:length(eventtime)
    c_e_diff=abs(camera_clock-eventtime(i));
    [c_e_diff_min(i),eventInd(i)]=min(c_e_diff);    
end
eventDuration=10;
eventIndOff=eventInd+eventDuration;
eventTrace=zeros(size(camera_clock));

for i=1:length(eventInd)
eventTrace(eventInd(i):eventIndOff(i))=1;
end
signalTrace=signal_ori;
signalTrace(:,3)=eventTrace;

MarkerInper=eventTrace;
Ch1=signalTrace(:,1);
Ch2=signalTrace(:,2);
Fibertable=table(Ch1,Ch2,MarkerInper);
writetable(Fibertable,[pathname,'Fiber_data_inper.csv']);


sampleFrequency=length(camera_clock)/camera_clock(end)*k_time
figure('name','MarkerInper')
plot(MarkerInper);
text(length(MarkerInper)/2,0.5,['sampleFrequency=',num2str(sampleFrequency)]);


