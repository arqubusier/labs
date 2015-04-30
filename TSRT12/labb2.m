% labb 2
s=tf('s');
p=bodeoptions;
p.MagUnits = 'dB';
%% 4
bodeplot(32/(s+8));
%% 9
%a
Kdubbel = 14.93;
T = 18.33
G = Kdubbel/(T*s + 1)^2;  
margin(G)

%% b
phimd = 70; %fig 5.11
%c
Tr = 5.5;
wcd = 1.45/Tr %fig 5.12
%% d
wc = 0.204;
phim = 30;
phimax = phimd - phim + 6
be = 0.17; %fig5.13
Td = 1/(wcd*sqrt(be))
K = sqrt(be)/(Kdubbel/(T^2*wcd^2 + 1))
F = K*(Td*s+1)/(be*Td*s + 1);
margin(F*G);
pause;
step(F*G/(1+F*G));
%% e
e0_d = 0.05;
e0 = 1/(1+K*Kdubbel)
ga = e0_d/e0
Ti = 10/wcd
atand((1-ga)*Ti*wcd/(ga+Ti^2*wcd^2))

%K = 0.694;
%Ti = 15;
%Td = 4.6188;
%be = 0.12;
%ga = 0.1488;

F = K*(Td*s+1)/(be*Td*s + 1)*(Ti*s + 1)/(Ti*s + ga);

%Open system
margin(F*G);
pause;
%Step response of closed system
step(F*G/(1+F*G));