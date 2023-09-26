function plotMatrix(x,y,colorpatch)

% x=peri_time;
% y=allSignalsgreen';
% colorpatch=[1,0,0];

plotNO=size(y,2);
colorweight=linspace(1,0.3,plotNO);
if size(x,1)==1
    x=x';
    x=repmat(x,1,plotNO);
elseif size(x,2)==1
    x=repmat(x,1,plotNO);      
end
for lineNO=1:plotNO
    hold on;
    plot(x(:,lineNO),y(:,lineNO),'color',colorweight(lineNO)*colorpatch)
    hold on;
end