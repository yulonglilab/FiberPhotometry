clearvars -except newpath;
[filename, pathname]=getlastfile('*.mat','Load file',0);
if pathname==0
    return;
end
load([pathname,filename]);
Fiber.ff475.heatmap.mean=mean(Fiber.ff475.heatmap.value)';
Fiber.ff475.heatmap.value=Fiber.ff475.heatmap.value';
Fiber.ff570.heatmap.mean=mean(Fiber.ff570.heatmap.value)';
Fiber.ff570.heatmap.value=Fiber.ff570.heatmap.value';
samplefrequency=100;
%% S/N peak/antagonist
% dff475=(Fiber.ff475.value-min(Fiber.ff475.value))/min(Fiber.ff475.value);
% stdff475=std(dff475);
% 
% SNRDA=DA3peak/stdff475;
% SNRdLight=dLightPeak/stdff475;
%% 
trialsno=length(Fiber.ff475.heatmap.pre);
for i=1:trialsno
    currenttrace=Fiber.ff475.heatmap.value(:,i);
    figure('name',[num2str(i),'_trial'])
    findpeaks(smooth(currenttrace,10),samplefrequency);
    peakvalues475(i)=max(findpeaks(smooth(currenttrace,10)));
    hold on;
    peakind=find(smooth(currenttrace,10)==peakvalues475(i));
    plot(peakind/samplefrequency,peakvalues475(i),'Marker','o','color','r');
    hold off;    
    baselineind=1:(Fiber.basetime+Fiber.pretime)*samplefrequency;    
    stdbase475(i)=std(currenttrace(baselineind));      
    
    currenttrace=Fiber.ff570.heatmap.value(:,i);
    figure('name',[num2str(i),'_trial'])
    findpeaks(smooth(currenttrace,10),samplefrequency);
    peakvalues570(i)=max(findpeaks(smooth(currenttrace,10)));
    hold on;
    peakind=find(smooth(currenttrace,10)==peakvalues570(i));
    plot(peakind/samplefrequency,peakvalues570(i),'Marker','o','color','r');
    hold off;    
    baselineind=1:(Fiber.basetime+Fiber.pretime)*samplefrequency;    
    stdbase570(i)=std(currenttrace(baselineind));   
    
    
end

S2N475=peakvalues475./stdbase475;
S2N475=S2N475';
S2N570=peakvalues570./stdbase570;
S2N570=S2N570';
xtime=linspace(-1*(Fiber.basetime+Fiber.pretime),Fiber.posttime,length(Fiber.ff475.heatmap.value))';

%%

xdata=(1:length(Fiber.ff475.dFF))/Fiber.ff475.SampleFrequency/60;
ydata{1}=Fiber.ff475.dFF;
ydata{2}=Fiber.ff570.dFF;
ydata{3}=Event.channel.level;
plotff475ff570Event(xdata,ydata);
PeakV475=reshape(peakvalues475,5,[]);
PeakV570=reshape(peakvalues570,5,[]);
