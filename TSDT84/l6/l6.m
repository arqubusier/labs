%%
n = -5:19;   % Anm: I boken står det (0:19), men från -5 är lämpligare
x = inline('n==0');     % = enhetsimpulsen
a = [1 -0.6 -0.16]; b = [5 0 0];
h = filter(b,a,x(n));
%clf; stem(n,h,'k'); xlabel('n'); ylabel('h[n]');

%%
%c
aa = [1 -1]; ba = [0 1];
ab = [1 -5 6]; bb = [0 8 -19];
ad = [1 0]; bd = [2 -2];
ha = filter(ba, aa, x(n));
hb = filter(bb, ab, x(n));
hd = filter(bd, ad, x(n));
%%
clf; stem(n, ha, 'k'); xlabel('n'); ylabel('ha[n]'); axis([0 19 -0.5 1.5])
pause
clf; stem(n, hb, 'k'); xlabel('n'); ylabel('hb[n]'); %axis([0 10 -4 1000])
pause
clf; stem(n, hd, 'k'); xlabel('n'); ylabel('hd[n]');
pause
%%
%e1
n=0:50;
x=inline('2*(n>=5 & n<20)','n');    % x[n]=2(u[n-5]-u[n-20])
h=inline('1*(n>=2 & n<10)','n');    % h[n]=u[n-2]-u[n-10]

subplot(2,1,1)
stem(n,x(n),'b');hold on, 
stem(n,h(n),'r');hold off
xlabel('n')
title('x[n]  (blå)  & h[n]  (röd)')

y=conv(x(n-10),h(n));       % y[n]=x[n-10]*h[n]  (faltning)
subplot(2,1,2) 
stem(n,y(1:length(n-10)));  % Ty length(y) = length(x)+length(h)-1
xlabel('n')
title('y[n]')
pause
%%
%e2
n=0:50;
x=inline('cos(pi/6*n).*(n>=0)','n');    % x[n]=2(u[n-5]-u[n-20])
h=inline('(1.5*0.95.^n).*(n>=0 & n<11)','n');    % h[n]=u[n-2]-u[n-10]

subplot(2,1,1)
stem(n,x(n),'b');hold on, 
stem(n,h(n),'r');hold off
xlabel('n')
title('x[n]  (blå)  & h[n]  (röd)')

y=conv(x(n),h(n));       % y[n]=x[n-10]*h[n]  (faltning)
subplot(2,1,2) 
stem(n,y(1:length(n)));  % Ty length(y) = length(x)+length(h)-1
xlabel('n')
title('y[n]')
pause

