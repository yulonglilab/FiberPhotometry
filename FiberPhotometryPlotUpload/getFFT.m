function [Power,frq]=getFFT(data,Fs)
% data需要计算FFT的数据
% Fs 数据data的采样频率
% Power fft计算后frq对应的幅度
% frq fft计算后的频率


L=length(data);%数据长度
fft_data = fft(data);%对数据进行快速傅里叶变换
P2 = abs(fft_data/L);%fft后的信号除以信号长度L
Power = P2(1:L/2+1);%得到单边谱Power
Power(2:end-1) = 2*Power(2:end-1);%由于P1(1)是直流吧
frq = Fs*(0:(L/2))/L;%采样频率Fs,因此只看fs/2内的信号
figure ('name','fft')
plot(frq,Power) 
title('Single-Sided Amplitude Spectrum')
xlabel('Frequency (Hz)')
ylabel('Power');
