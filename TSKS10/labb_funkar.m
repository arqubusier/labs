%%Initialize
N = 7.8*10^6;
[y,Fs] = wavread('signal-herlu184.wav');
f = Fs*linspace(0,1/2,N/2);
t = 0:1/Fs:(N-1)*1/Fs;
%% 
% Determine the tau2-tau1 by studying the correlation of y
% with itself. The Peak values are derived from the plot in this section
% 
y_c = xcorr(y, y);
plot(y_c);

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
%The correlation shows that the left and right peaks have been
%removed
plot(x_c1)
%%
% Determine fc
X = fft(x);
%The plot shows three distinct bands at frequencies with multiples of
%19 kHz
plot(f, abs(X(1:end/2)))

%Filtering out each band and inverse transforming it shows that the
%heighest band matches the signal description (three distinctive parts,
%the last one being white noise)
ze = zeros(1, N/2);
X_target1 = ze;
X_target2 = ze;
X_target3 = ze;
X_target1(0.2/2*N/2:0.6/2*N/2) = X(0.2/2*N/2:0.6/2*N/2);
X_target2(0.7/2*N/2:1.1/2*N/2) = X(0.7/2*N/2:1.1/2*N/2);
X_target3(1.3/2*N/2:1.7/2*N/2) = X(1.3/2*N/2:1.7/2*N/2);
X_target = X_target3;
x_target = ifft(X_target, 'symmetric');

plot(x_target)

%fc i determined by looking at the centrum of the heighest band of X
fc = 152*10^3;
%% Demodulera
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

plot(t, xi)
figure
plot(t, xq)
Fs_ = Fs/10

%wavwrite(xi, 'xi');
soundsc(xi(1:20:end), Fs/20)
pause
soundsc(xq(1:20:end), Fs/20)  
%wavwrite(xq, 'xq');

%Xi inget ont som inte har n�got gott med sig
%Xq v�ck inte den bj�rn som sover