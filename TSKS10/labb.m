%%Init
N = 7.8*10^6;
%% ladda fil
[y,Fs] = wavread('signal-herlu184.wav');

%% Plotta i tidsdomän
x_time = 0:1/Fs:(N-1)*1/Fs;
%%
plot(x_time,y)
%38, 95, 152 kHz

%% Plotta i frekvensdomän
%X_time = -Fs/2:Fs/N:Fs/2-Fs/N;
%bara intresserad av halva spektrat
X_freq = Fs*linspace(0,1/2,N/2);
%%
X = fft(y);
plot(X_freq, abs(X(1:end/2)))

%% Bestäm fc genom att undersöka de 3 olika frekvensområdena
%Bandpass-filtrera relevant spektra
ze = zeros(1, N/2);
X_target1 = ze;
X_target2 = ze;
X_target3 = ze;
X_target1(0.2/2*N/2:0.6/2*N/2) = X(0.2/2*N/2:0.6/2*N/2);
X_target2(0.7/2*N/2:1.1/2*N/2) = X(0.7/2*N/2:1.1/2*N/2);
X_target3(1.3/2*N/2:1.7/2*N/2) = X(1.3/2*N/2:1.7/2*N/2);
X_target = X_target3;
x_target = ifft(X_target(1.3/2*N/2:1.7/2*N/2),'symmetric');

plot(X_freq, abs(X_target))
pause;
plot(x_target)
%% fc
fc = 152*10^3;

%% Undersök tidsfördröjning genom att korrelera y
y_c = xcorr(y, y);
plot(y_c);
%%
%peaks = findpeaks(x_c, 'minPeakHeight', 500)
lpeak = 7.644*10^6;
mpeak = 7.800*10^6;
rpeak = 7.956*10^6;
tau_diff_samples = rpeak-mpeak; %tau2 - tau1 in # of samples
%% Filtrera ut eko
y_no_echo = y;
for i = tau_diff_samples+1:length(y_no_echo)
    y_no_echo(i) = y_no_echo(i) - 0.9*y_no_echo(i-tau_diff_samples);
end
y_c1 = xcorr(y_no_echo, y_no_echo);
plot(y_c1)
%% Demodulera
B = 0.2*10^5
%mix
xi_mixer = cos(2*pi*fc*x_time);
xq_mixer = sin(2*pi*fc*x_time);
xi_ = 2*(xi_mixer.*y_no_echo.');
xq_ = -2*(xq_mixer.*y_no_echo.');
Xi_ = fft( xi_(1:end/2) );
Xq_ = fft( xi_(1:end/2) );

%lowpassfilter
Xi = Xi_(1:0.15/2*N/2);
Xq = Xq_(1:0.15/2*N/2);
xi = ifft(Xi, 'symmetric');
xq = ifft(Xq, 'symmetric');

plot(xi)
%pause;
plot(xq)

wavwrite(xi, 'xi')