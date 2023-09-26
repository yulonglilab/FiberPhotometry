clearvars -except newpath;
%
[filename, pathname]=getlastfile('*.mat','Open File',0);
if pathname==0
    return;
end
load([pathname,filename]);
%% find peaks
trials=size(Fiber.ff475.heatmap.value,1);
x=Fiber.ff475.heatmap.xtime;
colorpool.ff475=[0.1,0.5,0.1];
colorpool.ff570=[0.5,0.1,0.1];
colorpool.smooth=[1,0,1];

figure('name','find peaks of ff475')
for i=1:trials      
%     ff475smooth=smooth(x,Fiber.ff475.heatmap.value(i,:),0.001,'rloess');
    ff475smooth=smooth(Fiber.ff475.heatmap.value(i,:),10);

    pause(0.1);
    try
        delete(h_trial);
        delete(h_peak);
    catch        
    end
    plot(x,Fiber.ff475.heatmap.value(i,:),'color',colorpool.ff475)
    tx=0.8*get(gca,'xlim');
    ty=0.8*get(gca,'ylim');
    h_trial=text(tx,ty,['trials ',num2str(i)],'color','k','FontSize',13);    
    hold on;
    plot(x,ff475smooth,'color',colorpool.smooth);    
    
    peaksRang=[0,10];%unit second
    
    xPeaks_on=findnearest(peaksRang(1),x);
    xPeaks_end=findnearest(peaksRang(2),x);

    [peaks475(i),locs]=findPeaksInTrace(ff475smooth(xPeaks_on:xPeaks_end),1,0);    

    h_peak=text(x(locs+xPeaks_on-1),peaks475(i),['peak ',num2str(peaks475(i))],'color','k','FontSize',13);
    hold off;
    
end

figure('name','find peaks of ff570')
for i=1:trials      
%     ff570smooth=smooth(x,Fiber.ff570.heatmap.value(i,:),0.001,'rloess');
        ff570smooth=smooth(Fiber.ff570.heatmap.value(i,:),10);

    pause(0.2);
    try
        delete(h_trial);
        delete(h_peak);
    catch        
    end
    plot(x,Fiber.ff570.heatmap.value(i,:),'color',colorpool.ff570)
    tx=0.8*get(gca,'xlim');
    ty=0.8*get(gca,'ylim');
    h_trial=text(tx,ty,['trials ',num2str(i)],'color','k','FontSize',13);    
    hold on;
    plot(x,ff570smooth,'color',colorpool.smooth);    
    
    peaksRang=[0,10];%unit second
    
    xPeaks_on=findnearest(peaksRang(1),x);
    xPeaks_end=findnearest(peaksRang(2),x);

    [peaks570(i),locs]=findPeaksInTrace(ff570smooth(xPeaks_on:xPeaks_end),1,0);    

    h_peak=text(x(locs+xPeaks_on-1),peaks570(i),['peak ',num2str(peaks570(i))],'color','k','FontSize',13);
    hold off;
    
end

peaks475mean=reshape(peaks475,5,[]);
peaks570mean=reshape(peaks570,5,[]);

filename(end-4:end)=[];
filenametosave=[pathname,filename,'_peaks.mat'];
save(filenametosave,'peaks475','peaks570','peaksRang','peaks475mean','peaks570mean');