%%Initialize
N = 7.8*10^6;
[y,Fs] = wavread('signal-herlu184.wav');
f = Fs*linspace(0,1/2,N/2);
t = 0:1/Fs:(N-1)*1/Fs;
%% 
% Determine the tau2-tau1 by studying the
% correlation of y with itself. The Peak 
% values are derived from the plot in
% this section
% 
y_c = xcorr(y, y);
n_c = linspace(-7.8e+06, 7.8e+06, 15599999);
plot(n_c ,y_c);

axis([-10^6 10^6 -1500 2000])
set(gca,'FontSize',20)
xlabel('\bf{n}', 'Interpreter', 'Latex', 'FontSize', 24);
ylabel('$\mathbf{r[n]}$', 'Interpreter', 'Latex', 'FontSize', 24);
print('fig1','-dpdf');

lpeak = 7.644*10^6;
mpeak = 7.800*10^6;
rpeak = 7.956*10^6;

%tau2 - tau1 in # of samples
n_delta = rpeak-mpeak;
tau_diff = n_delta*1/Fs;
%%
% Filter out echo in the time domain.
% x is the signal with the echo removed
%
x = y;
for i = n_delta+1:length(x)
    x(i) = x(i) - 0.9*x(i-n_delta);
end

x_c1 = xcorr(x, x);
%The correlation shows that the left and
%right peaks have been removed
plot(x_c1)
%%
% Determine fc
X = fft(x);
F = linspace(0, 1/2, 3900000);
%The plot shows three distinct bands at
%frequencies with multiples of
%19 kHz
plot(F, abs(X(1:end/2)))
set(gca,'FontSize',16)
ylabel('$\mathbf{X[n]}$', 'Interpreter', 'Latex','FontSize',22);
xlabel('\bf{F}', 'Interpreter', 'Latex','FontSize',22);
%%
% Filtering out each band and inverse
% transforming it shows that the
% heighest band matches the signal
% description (three distinctive parts,
% the last one being white noise)
ze = zeros(1, N);
X_target1 = ze;
X_target2 = ze;
X_target3 = ze;
X_target1(0.2/2*N/2:0.6/2*N/2) = X(0.2/2*N/2:0.6/2*N/2);
X_target2(0.7/2*N/2:1.1/2*N/2) = X(0.7/2*N/2:1.1/2*N/2);
X_target3(1.3/2*N/2:1.7/2*N/2) = X(1.3/2*N/2:1.7/2*N/2);
x_target1 = ifft(X_target1, 'symmetric');
x_target2 = ifft(X_target2, 'symmetric');
X_target = X_target3;
x_target = ifft(X_target, 'symmetric');

subplot(3,1,1)
plot(x_target1)
set(gca,'FontSize',18,'xtick',[])
ylabel('$\mathbf{x_1[n]}$', 'Interpreter', 'Latex','FontSize',22);
subplot(3,1,2)
plot(x_target2)
set(gca,'FontSize',18,'xtick',[])
ylabel('$\mathbf{x_2[n]}$', 'Interpreter', 'Latex','FontSize',22);
subplot(3,1,3)
plot(x_target) 
set(gca,'FontSize',18)
ylabel('$\mathbf{x_3[n]}$', 'Interpreter', 'Latex','FontSize',22);
xlabel('\bf{n}', 'Interpreter', 'Latex','FontSize',22);
%print('fig2','-dpdf');

%fc i determined by looking at the
%centrum of the heighest band of X
fc = 152*10^3;
%% 
% Demodulate
%
% The delay of x(t) results in a phase
% shift in the xi, and xq components.
% This value lies somewhere between zero
% and pi/2. The phase shift below was
% derived by testing different values
% until the message could be heard.
%
phase_shift = 0.8;
xi_mixer = cos(2*pi*fc*t+phase_shift);
xq_mixer = sin(2*pi*fc*t+phase_shift);
xi_ = 2*xi_mixer.*x_target;
xq_ = -2*xq_mixer.*x_target;
Xi_ = fft( xi_ );
Xq_ = fft( xq_ );

%lowpass filter
Xi = zeros(1,N);
Xq = zeros(1,N);
Xi(1:0.4/2*N/2) = Xi_(1:0.4/2*N/2);
Xq(1:0.4/2*N/2) = Xq_(1:0.4/2*N/2);
xi = ifft(Xi, 'symmetric');
xq = ifft(Xq, 'symmetric');

plot(f, abs(Xq(1:end/2)));

Fs_ = Fs/10

soundsc(xi(1:20:end), Fs/20)
pause
soundsc(xq(1:20:end), Fs/20)

%Xi: "Inget ont som inte har något gott
%med sig."

%Xq: "Väck inte den björn som sover."