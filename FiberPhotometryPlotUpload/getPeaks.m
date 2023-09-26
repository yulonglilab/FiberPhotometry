clearvars -except newpath;
[filename, pathname]=getlastfile('*.mat','Load file',0);
if pathname==0
    return;
end
load([pathname,filename]);

figure('name','ff475')
%findpeaks(smooth(Fiber.ff475.value,smoothstep),samplefrequency);
samplefrequency=length(Fiber.ff475.dFF_smooth)/length(Fiber.ff475.dFF)*Fiber.ff475.SampleFrequency;
xtime=(0:length(Fiber.ff475.dFF_smooth)-1)/samplefrequency;
plot(xtime,Fiber.ff475.dFF_smooth);
peakvalues475=max(findpeaks(Fiber.ff475.dFF_smooth));
hold on;
peakind=find(Fiber.ff475.dFF_smooth==peakvalues475);
plot(peakind/samplefrequency,peakvalues475,'Marker','o','color','r');
hold off;

figure('name','ff570')
%findpeaks(smooth(Fiber.ff570.value,smoothstep),samplefrequency);
samplefrequency=length(Fiber.ff570.dFF_smooth)/length(Fiber.ff570.dFF)*Fiber.ff570.SampleFrequency;
xtime=(0:length(Fiber.ff570.dFF_smooth)-1)/samplefrequency;
plot(xtime,Fiber.ff570.dFF_smooth);
peakvalues570=max(findpeaks(Fiber.ff570.dFF_smooth));
hold on;
peakind=find(Fiber.ff570.dFF_smooth==peakvalues570);
plot(peakind/samplefrequency,peakvalues570,'Marker','o','color','r');
hold off;

peakvalues475r=peakvalues475-min(Fiber.ff475.dFF_smooth);
peakvalues570r=peakvalues570-min(Fiber.ff570.dFF_smooth);

peakRatio=peakvalues570r/peakvalues475r;
peakValues=[peakvalues475r,peakvalues570r,peakRatio];
filename
