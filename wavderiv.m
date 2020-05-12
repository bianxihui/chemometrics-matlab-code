function [data]=wavderiv(dat,wavefilter,scale)

%dat: the original data;
%wavefitler: the wavelet fitlers used;
%scale: the wavelet scale used.

[rowlen,collen]=size(dat);

for s=1:rowlen
   wl=[dat(s,collen:-1:1) dat(s,:) dat(s,collen:-1:1)];%把数据左右都翻转，保证边缘信号不失真
   df=cwt(wl,scale,wavefilter);%进行连续小波变换
   data(s,:)=df(:,(collen+1):2*collen);%仅把原始数据对应的中间一段保留下来
   clear wl df;
end
% Available wavelet names 'wname' are:
%    Daubechies: 'db1' or 'haar', 'db2', ... ,'db45'
%    Coiflets  : 'coif1', ... ,  'coif5'
%    Symlets   : 'sym2' , ... ,  'sym8', ... ,'sym45'
%    Discrete Meyer wavelet: 'dmey'
%    Biorthogonal:
%        'bior1.1', 'bior1.3' , 'bior1.5'
%        'bior2.2', 'bior2.4' , 'bior2.6', 'bior2.8'
%        'bior3.1', 'bior3.3' , 'bior3.5', 'bior3.7'
%        'bior3.9', 'bior4.4' , 'bior5.5', 'bior6.8'.
%    Reverse Biorthogonal: 
%        'rbio1.1', 'rbio1.3' , 'rbio1.5'
%        'rbio2.2', 'rbio2.4' , 'rbio2.6', 'rbio2.8'
%        'rbio3.1', 'rbio3.3' , 'rbio3.5', 'rbio3.7'
%        'rbio3.9', 'rbio4.4' , 'rbio5.5', 'rbio6.8'.

