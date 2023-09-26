function [xreshapemean,xreshape]=ReshapeFixedStep(x,step)
xlength=length(x);
modx=mod(xlength,step);
coulmn=floor(xlength/step);
if modx>0
    leftmatrix=reshape(x(1:(coulmn*step)),step,coulmn);
    leftmean=mean(leftmatrix);
    lastmean=mean(x((coulmn*step):end));
    xreshapemean=[leftmean,lastmean];
    rightmatrix=x((coulmn*step+1):end);
    if size(rightmatrix,1)<size(rightmatrix,2)
        rightmatrix=rightmatrix';
    end
    patchzeros=zeros(step-modx,1);
    rightmatrix=[rightmatrix;patchzeros];
    xreshape=[leftmatrix,rightmatrix];
elseif modx==0
    xreshape=reshape(x,step,coulmn);
    xreshapemean=mean(xreshape);   
end