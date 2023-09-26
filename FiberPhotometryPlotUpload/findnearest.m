
function [xind,an_x]=findnearest(x,an)
    x_an_diff=abs(x-an);
    [an_x,xind]=min(x_an_diff);    
end