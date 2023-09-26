function plotff475ff570Event(xdata,ydata,colorpool)



colorpool=[0.4660, 0.6740, 0.1880;0.8500, 0.3250, 0.0980;0, 0, 0];

figure('name','dFF');
ha = tight_subplot(3,1,[.03 .03],[.1 .01],[.1 .01]);
axes(ha(1));
plot(xdata,ydata{1},'color',colorpool(1,:));
xlim([min(xdata),max(xdata)]);
set(gca,'TickDir','out');
axis tight
set(gca,'box','off','xtick',[]);
ha(1).XAxis.Visible = 'off';
set(gca,'box','off');
set(gca,'color','none');

axes(ha(2));
plot(xdata,ydata{2},'color',colorpool(2,:));
xlim([min(xdata),max(xdata)]);
set(gca,'TickDir','out');
axis tight
set(gca,'box','off','xtick',[]);
ha(2).XAxis.Visible = 'off';
set(gca,'box','off');
set(gca,'color','none');
axes(ha(3));
plot(xdata,ydata{3},'color',colorpool(3,:));
xlim([min(xdata),max(xdata)]);
set(gca,'TickDir','out');
set(gca,'box','off');
set(gca,'color','none');
ylim([0.2,1]);
xlabel('Time(min)');