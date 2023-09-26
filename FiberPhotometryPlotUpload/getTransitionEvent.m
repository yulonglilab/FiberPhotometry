%% CPP
clearvars -except newpath;
[filename, pathname]=getlastfile({'*.xlsx';'*.csv';'*.xls'},'Load event file',0);
if pathname==0
    return;
end
EventTable=readtable([pathname,filename]);
TransTime=EventTable.TransitionRel_Time_Seconds_;
HoldTime=EventTable.TransitionTimeInZone_Seconds_;
ZoneState=EventTable.TransitionCurrentZone;
for i=1:length(TransTime)
    if  ~isempty(strfind(ZoneState{i},'Exclusion'))
        ExclusionInd= i ;
    end
end
try
    TransTime(ExclusionInd)=[];
    HoldTime(ExclusionInd)=[];
    ZoneState(ExclusionInd)=[];
catch
end
%% get transition event index
% Zone 2 Saline(Sal), Zone 3 Cocaine(Coca), Zone 5 Center(CTR)
CTR2CocaInd=zeros(size(ZoneState));
CTR2SalInd=zeros(size(ZoneState));
Coca2CTRInd=zeros(size(ZoneState));
Sal2CTRInd=zeros(size(ZoneState));
HoldTimeThreshhold=inputdlg('Enter threshhold time (s),e.g.1 ','threshhold time');
HoldTimeThreshhold= str2num(HoldTimeThreshhold{1}); %second

delaytime=inputdlg('Enter delaytime (s),e.g.100 ','delaytime');
delaytime= str2num(delaytime{1}); %second

timeRange=inputdlg('Enter time range (s),e.g.100,2000 ','time range');
timeRange= str2num(timeRange{1}); %second
timeRangeOn=timeRange(1);
timeRangeOff= timeRange(2); %second
TransTime=TransTime+delaytime;

for i=2:length(ZoneState)
    if HoldTime(i)<HoldTimeThreshhold || HoldTime(i-1)<HoldTimeThreshhold
         disp(i);
        continue;
    end    
    
    if TransTime(i) <timeRangeOn || TransTime(i) >timeRangeOff        
        continue;
    end
    
    
    %% Center(CTR) to Cocaine(Coca)    
    if ~isempty(strfind(ZoneState{i-1},'5')) && ~isempty(strfind(ZoneState{i},'3'))
        CTR2CocaInd(i)=1;
    end
    %% Center(CTR) to Saline(Sal)    
    if ~isempty(strfind(ZoneState{i-1},'5')) && ~isempty(strfind(ZoneState{i},'2'))
        CTR2SalInd(i)=1;
    end
     %% Cocaine(Coca) to Center(CTR)    
    if ~isempty(strfind(ZoneState{i-1},'3')) && ~isempty(strfind(ZoneState{i},'5'))
        Coca2CTRInd(i)=1;
    end
     %% Saline(Sal) to Center(CTR)    
    if ~isempty(strfind(ZoneState{i-1},'2')) && ~isempty(strfind(ZoneState{i},'5'))
        Sal2CTRInd(i)=1;
    end
end
CTR2CocaInd=find(CTR2CocaInd);
CTR2SalInd=find(CTR2SalInd);
Coca2CTRInd=find(Coca2CTRInd);
Sal2CTRInd=find(Sal2CTRInd);
%%
% clearvars -except newpath;
[filename, pathname]=getlastfile({'*.mat'},'Load Fiber DATA file',0);
if pathname==0
    return;
end
load([pathname, filename]);

basetime=5; % second
pretime=5; % second
posttime=10; % second

baselen=round(basetime/ff475.interval);
prelen=round(pretime/ff475.interval);
postlen=round(posttime/ff475.interval);

offset=inputdlg('Enter offset ,e.g.1.5 ','offset');
offset=  str2num(offset{1});

CTR2CocaTimeInd=round(TransTime(CTR2CocaInd)/ff475.interval);  
CTR2Coca=getdFF_P_FIBPP(ff475.values-offset,CTR2CocaTimeInd,baselen,prelen,postlen);
CTR2Cocamean=mean(CTR2Coca);
xtime=linspace(-1*(basetime+pretime),posttime,length(CTR2Cocamean));
%%
figure ('name','peri-event time histograms')
%% Center(CTR) to Cocaine(Coca)

subplot(2,4,1)
imagesc(xtime,1:length(CTR2CocaTimeInd),CTR2Coca);
ylabel('Trial#');
xlabel('Time (s)');
title('CTR to Coca');
subplot(2,4,2)
plot(xtime,CTR2Cocamean);
ylabel('dFF');
xlabel('Time (s)');
title('CTR to Coca');

%% Center(CTR) to Saline(Sal)
CTR2SalTimeInd=round(TransTime(CTR2SalInd)/ff475.interval);  
CTR2Sal=getdFF_P_FIBPP(ff475.values-offset,CTR2SalTimeInd,baselen,prelen,postlen);
CTR2Salmean=mean(CTR2Sal);
subplot(2,4,3)
imagesc(xtime,1:length(CTR2SalTimeInd),CTR2Sal);
ylabel('Trial#');
xlabel('Time (s)');
title('CTR to Sal');
subplot(2,4,4)
plot(xtime,CTR2Salmean);
ylabel('dFF');
xlabel('Time (s)');
title('CTR to Sal');
%% Cocaine(Coca) to Center(CTR)
Coca2CTRTimeInd=round(TransTime(Coca2CTRInd)/ff475.interval);  
Coca2CTR=getdFF_P_FIBPP(ff475.values-offset,Coca2CTRTimeInd,baselen,prelen,postlen);
Coca2CTRmean=mean(Coca2CTR);
subplot(2,4,5)
imagesc(xtime,1:length(Coca2CTRTimeInd),Coca2CTR);
ylabel('Trial#');
xlabel('Time (s)');
title('Coca to CTR');
subplot(2,4,6)
plot(xtime,Coca2CTRmean);
ylabel('dFF');
xlabel('Time (s)');
title('Coca to CTR');
%% Saline(Sal) to Center(CTR)
Sal2CTRTimeInd=round(TransTime(Sal2CTRInd)/ff475.interval);  
Sal2CTR=getdFF_P_FIBPP(ff475.values-offset,Sal2CTRTimeInd,baselen,prelen,postlen);
Sal2CTRmean=mean(Sal2CTR);
subplot(2,4,7)
imagesc(xtime,1:length(Sal2CTRTimeInd),Sal2CTR);
ylabel('Trial#');
xlabel('Time (s)');
title('Sal to CTR');
subplot(2,4,8)
plot(xtime,Sal2CTRmean);
ylabel('dFF');
xlabel('Time (s)');
title('Sal to CTR');

saveas(gcf, [pathname,filename,'_peri-event time histograms.pdf']);

%% 
Fvalues=ff475.values(round(TransTime(1)/ff475.interval):round((TransTime(end)+HoldTime(end))/ff475.interval));
signals=detrendF(Fvalues); % detrend
F0=min(signals);
dFFAll=(signals-F0)/F0;

colorpool.Coca=[212,168,215]/255;
colorpool.Sal=[255,207,146]/255;
colorpool.CTR=[222,226,239]/255;
colorpool.trace=[108,167,20]/255;
TransTime2=TransTime-delaytime;

xa=(1:length(Fvalues))*ff475.interval+delaytime;

figure('name','Trace_Pos')
subplot (2,1,1)
plot(xa,dFFAll,'color',colorpool.trace);
ticky=get(gca,'ylim');
for i = 1:numel(TransTime)       
    
    switch ZoneState{i}        
        case 'Zone 2'            
            currentColor=colorpool.Sal;
        case 'Zone 3'
            currentColor=colorpool.Coca;
        case 'Zone 5'
            currentColor=colorpool.CTR;
    end    
    hold on;
    area([TransTime(i) TransTime(i)+HoldTime(i)], [ticky(2) ticky(2)],ticky(1), 'FaceColor',currentColor,'edgecolor', 'none','FaceAlpha',0.5);
end
ylabel('dF/F0');
xlabel('Time (s)')

subplot(2,1,2)
  timeRangeOnInd=round((timeRangeOn-delaytime)/ff475.interval);
  timeRangeOffInd=round((timeRangeOff-delaytime)/ff475.interval);
  
plot(xa(timeRangeOnInd:timeRangeOffInd),dFFAll(timeRangeOnInd:timeRangeOffInd),'color',colorpool.trace);
ticky=get(gca,'ylim');
for i = 1:numel(TransTime)       
    if TransTime(i) <timeRangeOn || TransTime(i) >timeRangeOff        
        continue;
    end
    switch ZoneState{i}        
        case 'Zone 2'            
            currentColor=colorpool.Sal;
        case 'Zone 3'
            currentColor=colorpool.Coca;
        case 'Zone 5'
            currentColor=colorpool.CTR;
    end    
    hold on;
    area([TransTime(i) TransTime(i)+HoldTime(i)], [ticky(2) ticky(2)],ticky(1), 'FaceColor',currentColor,'edgecolor', 'none','FaceAlpha',0.5);
end
ylabel('dF/F0');
xlabel('Time (s)')
saveas(gcf, [pathname,filename,'dFFpdf.pdf']);

CPPdFF.CTR2Coca=CTR2Coca;
CPPdFF.CTR2Sal=CTR2Sal;
CPPdFF.Coca2CTR=Coca2CTR;
CPPdFF.Sal2CTR=Sal2CTR;

CPPdFF.CTR2Cocamean=CTR2Cocamean;
CPPdFF.CTR2Salmean=CTR2Salmean;
CPPdFF.Coca2CTRmean=Coca2CTRmean;
CPPdFF.Sal2CTRmean=Sal2CTRmean;
CPPdFF.trace=dFFAll;

save([pathname,filename,'_CPP','.mat'],'CPPdFF');


