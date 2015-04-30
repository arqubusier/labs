%% 3. Fourierserieanalys

%% a

% insinal
x = fouser('pulse(t,0,1) + pulse(t,7,8)', 8);
e_f = pwr(x);
%utsignal
y = remtone(x, 'lp', 6);
e_e = pwr(remtone(x, 'lp', 6));

e_kvot = e_e / e_f

%graf över utsignal
signal(y)
pause
spect(x,y)

for j = 6:30,
    pause
    fprintf('%d\n',j)
    y = remtone(x, 'lp', j);
    signal(y)
end