function signals=detrendF(signals,methords)
if nargin<2
    methords='2ndExp';
end

switch methords    
    case '2ndExp'
%         figure('name','2nd_order_exp_fit')        
%         [fitS,~] = ffExpFit(signals);
%         plot(signals,'color','k');
%         hold on;
%         x = 1:length(signals);
%         plot(fitS(x),'color',[1,0,0],'LineWidth',2);
%                hold on;
%         signals=signals-fitS(x)+min(fitS(x));
%         plot(signals);
        [fitS,~] = ffExpFit(signals);        
        x = 1:length(signals);       
        signals=signals-fitS(x)+min(fitS(x));        
end