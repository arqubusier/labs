initcourse TSDT18
startup

%% 4. a
 p=in('pulse(t,0,5)','t'); 
 P=foutr(p);
 spect(P)
 pause

%% 4. b
s1=in('sin(2*pi*200*t)*pulse(t,0,1/5)','t');
s2=in('sin(2*pi*200*t)*pulse(t,0,1/40)','t');
S1 = foutr(s1);
S2 = foutr(s2);
spect(S1)
pause
spect(S2)
pause
spect(S1,S2,400)
subplot(2,1,1), set(gca,'xlim',[175,225])
ohfig
pause
%%  4.c
load dtmf;
signal(toner)
TONER = foutr(toner);
pause
spect(TONER)
pause
%% 4.d
signal(ton)
TON = foutr(ton);
pause
spect(TON)


