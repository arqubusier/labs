
Kp = 1;
Ki = 1;
T = 0.1;
Kd = 10;
K = Kp + Ki/s + Kd*s/(s*T+1);
F = feedback(G*K,1);
figure;
step(F);

%%
a = 10;
G = (a*s + 1)/(s^2+2*s+1);
figure;
step(G);