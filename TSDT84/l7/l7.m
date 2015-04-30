%%
%a
load 'l7a.mat'
%%
%b
load l7b.mat
pzchange(HAz)
pause
pzchange(HBz)
%%
%c
[B,A]=butter(3, 2*0.15, 'low');
H=in(B, A, 'z');
pzchange(H)
%%
[B,A]=butter(5, 2*0.15, 'low');
Hb=in(B, A, 'z');

[B,A]=cheby1(5, 1, 2*0.15, 'low');
Hc=in(B, A, 'z');

pzchange(Hb)
pause
pzchange(Hc)
%%
[B,A]=butter(5, 2*0.15, 'high');
Hb=in(B, A, 'z');

[B,A]=cheby1(5, 1, 2*0.15, 'high');
Hc=in(B, A, 'z');

pzchange(Hb)
pause
pzchange(Hc)
%%
load dtmf, T=toner(65537); Dtoner=[toner 0 0 0]; N=30;
subplot(2,1,1), signalmod(toner,N*T);
subplot(2,1,2), signalmod(Dtoner,N);
pause
TONER=foutr(toner); DTONER=foutr(Dtoner);
spect(TONER,DTONER);
subplot(2,1,1), axis([0 3200 0 2])
%%
[B,A]=cheby1(2, 1, [2*pi*935 2*pi*1215], 'bandpass', 's');
Hct=in(B, A, 's');

pzchange(Hct)
%%
[B,A]=cheby1(2, 1, [2*pi*935 2*pi*1215], 'bandpass', 's');
Hct=in(B, A, 's');
[B,A]=cheby1(2, 1, [2*0.146 2*0.190], 'bandpass');
Hcd=in(B, A, 'z');

pzchange(Hcd)
pause
logspect(Hct, Hcd);
