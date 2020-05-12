function [df]=sgdiff(x,N,F,kinds)
%function [df]=sgdiff(x,N,F) is used to calculate the SG smoothing and
%derivative signal
%
%Input parameters:
%x: original signals;
%N: the order of SG smoothing, suggested value should be 2;
%F: the windows sizes of SG filter, it must be odd number, e.g. 3,5,7,9.....
%kinds: the kinds of SG smoothing or derivative calculation, default=0.
%          kinds=0, smoothing;
%          kinds=1, first derivative
%          kinds=2, second derivative
%Output parameters
%df:  SG filtered data
%
% Programmed by Da Chen, Department of Chemistry, Nankai University. 2007
%陈达程序 n = (F+1)/2:calcol-(F+1)/2
%这样平滑少了一个点，因此改为 n = (F+1)/2:calcol-(F+1)/2+1

[b,g]=sgolay(N,F);
[calrow,calcol]=size(x);
[xrow,xcol]=size(x);
kk=1; 
if nargin==3
    kinds=0;
end

for n = (F+1)/2:calcol-(F+1)/2+1,
% Zero-th order derivative (equivalent to sgolayfilt except
% that it doesn't compute transients)
 if kinds==0
    df(:,kk)=(g(:,1)'*x(:,n - (F+1)/2 + 1: n + (F+1)/2 - 1)')';
end
% 1st order derivative
if kinds==1
   df(:,kk)=(g(:,2)'*x(:,n - (F+1)/2 + 1: n + (F+1)/2 - 1)')';
end
% 2nd order derivative
if kinds==2
    df(:,kk)=(2*g(:,3)'*x(:,n - (F+1)/2 + 1: n + (F+1)/2 - 1)')';
end
    kk=kk+1;
end
