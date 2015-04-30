%%
%b
load l3b.mat;
pzchange(H1)
pzchange(H2)
pause
%%
%c
load l3c.mat;
pzchange(H3)
pause
%%
%d
load l3d.mat
pzchange(H4)
pause
%%
%e

%Butterwoth-filter ordn 10
[B,A] = butter(10, 2*pi*100, 'low' ,'s');
pzchange(in(B,A,'s'))
pause

%Chebychev-filter ordn 5
[B,A] = cheby1(5, 3,  2*pi*100, 'low' ,'s');
pzchange(in(B,A,'s'))
pause

%%
%f
[B,A] = butter(3,[935*2*pi,1225*2*pi],'bandpass','s');
pzchange(in(B,A,'s'))
pause

%%
load dtmf
load l3f.mat
Y = output(foutr(toner), H5);
y = ifoutr(Y);
signal(y)
pause
spect(Y)
pause

pause
