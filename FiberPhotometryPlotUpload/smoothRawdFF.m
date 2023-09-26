clearvars -except newpath;
[currentfilename, pathname]=getlastfile('*.mat','Load file',0);
if pathname==0
    return;
end
load([pathname,currentfilename]);
step=200;
%% ff475 
ff475_smooth=ReshapeFixedStep(Fiber.ff475.dFF,step)';
xtime_smooth=ReshapeFixedStep(Fiber.xtime,step)';
figure('name','smoothtrace')
subplot(3,1,1)
plot(Fiber.xtime,Fiber.ff475.dFF);
subplot(3,1,2)
plot(xtime_smooth,ff475_smooth);
subplot(3,1,3);
plot(Fiber.xtime,Fiber.ff475.dFF);
hold on;
plot(xtime_smooth,ff475_smooth);
hold off;
Fiber.ff475.dFF_smooth=ff475_smooth;
Fiber.ff475.dFF_xtimesmooth=xtime_smooth;
ff570_smooth=ReshapeFixedStep(Fiber.ff570.dFF,step)';
xtime_smooth=ReshapeFixedStep(Fiber.xtime,step)';




%% ff570
figure('name','smoothtrace')
subplot(3,1,1)
plot(Fiber.xtime,Fiber.ff570.dFF);
subplot(3,1,2)
plot(xtime_smooth,ff570_smooth);
subplot(3,1,3);
plot(Fiber.xtime,Fiber.ff570.dFF);
hold on;
plot(xtime_smooth,ff570_smooth);
hold off;
Fiber.ff570.dFF_smooth=ff570_smooth;
Fiber.ff570.dFF_xtimesmooth=xtime_smooth;



% zscore ff475
baseonset=100;%s
baseoffset=150;%s
Fiber.ff475.basetime=[baseonset,baseoffset];

baseonsetind=ceil(baseonset/Fiber.ff475.interval);
baseoffsetind=ceil(baseoffset/Fiber.ff475.interval);
basedata=Fiber.ff475.dFF(baseonsetind:baseoffsetind);
Fiber.ff475.dFF_zscore=(Fiber.ff475.dFF-mean(basedata))/std(basedata);


interval=Fiber.ff475.interval*step;
baseonsetind=ceil(baseonset/interval);
baseoffsetind=ceil(baseoffset/interval);
basedata=ff475_smooth(baseonsetind:baseoffsetind);
ff475_smooth_zscore=(ff475_smooth-mean(basedata))/std(basedata);

% zscore ff570

baseonset=100;%s
baseoffset=150;%s
Fiber.ff570.basetime=[baseonset,baseoffset];
baseonsetind=ceil(baseonset/Fiber.ff570.interval);
baseoffsetind=ceil(baseoffset/Fiber.ff570.interval);
basedata=Fiber.ff570.dFF(baseonsetind:baseoffsetind);
Fiber.ff570.dFF_zscore=(Fiber.ff570.dFF-mean(basedata))/std(basedata);




interval=Fiber.ff570.interval*step;
baseonsetind=ceil(baseonset/interval);
baseoffsetind=ceil(baseoffset/interval);
basedata=ff570_smooth(baseonsetind:baseoffsetind);
ff570_smooth_zscore=(ff570_smooth-mean(basedata))/std(basedata);


figure('name','dFF_zscore')
plot(Fiber.xtime,Fiber.ff475.dFF_zscore,'g');
hold on;
plot(Fiber.xtime,Fiber.ff570.dFF_zscore,'r');
hold off;
Fiber.ff475.dFF_smooth_zscore=ff475_smooth_zscore;
Fiber.ff570.dFF_smooth_zscore=ff570_smooth_zscore;

figure('name','smooth_zscore')
plot(xtime_smooth,ff475_smooth_zscore,'g');
hold on;
plot(xtime_smooth,ff570_smooth_zscore,'r');

Fiber.ff475.dFF_smooth_zscore=ff475_smooth_zscore;
Fiber.ff570.dFF_smooth_zscore=ff570_smooth_zscore;

lowpassFrequency=0.3;
Fiber.ff475.dFF_filtered=lowpassbutter(Fiber.ff475.dFF,1/Fiber.ff475.interval,lowpassFrequency,2);
figure('name','filter VS smooth_475')
x_smooth=linspace(0,Fiber.xtime(end),length(Fiber.ff475.dFF_smooth));
plot(x_smooth,Fiber.ff475.dFF_smooth,'g');
hold on;
x_filter=linspace(0,Fiber.xtime(end),length(Fiber.ff475.dFF_filtered));
plot(x_filter,Fiber.ff475.dFF_filtered,'r');


Fiber.ff570.dFF_filtered=lowpassbutter(Fiber.ff570.dFF,1/Fiber.ff570.interval,lowpassFrequency,2);
figure('name','filter VS smooth_570')
x_smooth=linspace(0,Fiber.xtime(end),length(Fiber.ff570.dFF_smooth));
plot(x_smooth,Fiber.ff570.dFF_smooth,'g');
hold on;
x_filter=linspace(0,Fiber.xtime(end),length(Fiber.ff570.dFF_filtered));
plot(x_filter,Fiber.ff570.dFF_filtered,'r');

Fiber.ff475.lowpassFrequency=lowpassFrequency;
Fiber.ff570.lowpassFrequency=lowpassFrequency;


% save([pathname,currentfilename],'Event','Fiber','filename','peri_time');
