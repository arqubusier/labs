% lek2
%% 6.10

s = tf('s');
G = 725/(s+1)/(s+2.5)/(s+25);
Gdelta = -s/(s+1);
% fall 1
F = 1;
bodeplot(1/Gdelta, F*G/(1+F*G));
%robusthetskriteriet ej uppfyllt
%stabilitet kan ej garanteras
% fall 2
pause
F = 0.46*(0.43*s+1)*(2*s+1)/(0.09*s+1)/2*s
bodeplot(1/Gdelta, F*G/(1+F*G));
%% 9.14
s = tf('s');
G = 1/s/(s+1);
s = ss(G);
p1 = [-2.2, -2.1];
p2 = [-1+i, -1-i];
L1 = acker(s.a, s.b, p1)
L2 = acker(s.a, s.b, p2)
A1 = s.a-s.b*L1
A2 = s.a-s.b*L2

gas1 = ss(A1, s.b, s.c, 0)
gas2 = ss(A2, s.b, s.c, 0)

G1 = tf(gas1)
G2 = tf(gas2)

step(G1)
figure
step(G2)
figure
bodeplot(G1, G2)

%% 9.14 c
Q1 = [0, 0; 0, 1]
Q2 = [0, 0; 0, 10]
Q3 = [0, 0; 0, 0.1]

L1 = lqr(s, Q1, 1)
L2 = lqr(s, Q2, 1)
L3 = lqr(s, Q3, 1)

A1 = s.a-s.b*L1
A2 = s.a-s.b*L2
A3 = s.a-s.b*L3

gas1 = ss(A1, s.b, s.c, 0)
gas2 = ss(A2, s.b, s.c, 0)
gas3 = ss(A3, s.b, s.c, 0)

G1 = tf(gas1)
G2 = tf(gas2)/0.316
G3 = tf(gas3)/0.316

close all
step(G1)
figure
step(G2)
figure
step(G3)
figure
margin(G1)
figure
margin(G2)
figure
margin(G3)
