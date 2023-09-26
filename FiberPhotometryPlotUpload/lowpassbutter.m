function passdata=lowpassbutter(data,samplefrequency,lowfrequency,order)
if nargin<1
    error('no data');
end

if nargin<3
samplefrequency=100;
end
if nargin<3
lowfrequency=0.1;
end
if nargin<3
order=2;
end



fmaxn=lowfrequency/(samplefrequency/2);  
[a,b]=butter(order,fmaxn,'low');  
passdata=filtfilt(a,b,data);
filtereddata=data-passdata;          
figure('name','lowpass')
subplot(3,1,1),plot(data,'b');xlabel('ori');  
hold on;plot(passdata,'r');hold off;
subplot(3,1,2),plot(filtereddata,'b');xlabel('filtered'); 
subplot(3,1,3),plot(passdata,'b');xlabel('baseline');  



