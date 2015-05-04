%%Initialize
N = 7.8*10^6;
[y,Fs] = wavread('signal-herlu184.wav');
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
tau_diff_samples = rpeak-mpeak;
tau_diff = tau_diff_samples*1/Fs;
%%
% Filter out echo in the time domain.
% x is the signal with the echo removed
%
x = y;
for i = tau_diff_samples+1:length(x)
    x(i) = x(i) - 0.9*x(i-tau_diff_samples);
end
x_c1 = xcorr(x, x);

plot(x_c1)
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
Y = fft(y);
plot(X_freq, abs(Y(1:end/2)))

%% Bestäm fc genom att undersöka de 3 olika frekvensområdena
%Bandpass-filtrera relevant spektra
ze = zeros(1, N/2);
Y_target1 = ze;
Y_target2 = ze;
Y_target3 = ze;
Y_target1(0.2/2*N/2:0.6/2*N/2) = Y(0.2/2*N/2:0.6/2*N/2);
Y_target2(0.7/2*N/2:1.1/2*N/2) = Y(0.7/2*N/2:1.1/2*N/2);
Y_target3(1.3/2*N/2:1.7/2*N/2) = Y(1.3/2*N/2:1.7/2*N/2);
Y_target = Y_target3;
Y_target = ifft(Y_target(1.3/2*N/2:1.7/2*N/2),'symmetric');

plot(X_freq, abs(Y_target))
pause;
plot(x_target)
%% fc
fc = 152*10^3;
%% filtrera ut signal kring fc
X = fft(x);
plot(X_freq, abs(X(1:end/2)));
X_target = zeros(1, N);
X_target(1.3/2*N/2:1.7/2*N/2) = X(1.3/2*N/2:1.7/2*N/2);
x_target = ifft(X_target, 'symmetric');
%plot(X_freq, abs(X_target(1:end/2));
plot(x_time, x_target);
%% Demodulera
phase_shift = 0.8;
xi_mixer = cos(2*pi*fc*x_time+phase_shift);
xq_mixer = sin(2*pi*fc*x_time+phase_shift);
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

plot(X_freq, abs(Xq(1:end/2)));

plot(x_time, xi)
figure
plot(x_time, xq)
Fs_ = Fs/10

%wavwrite(xi, 'xi');
soundsc(xi(1:20:end), Fs/20)
pause
soundsc(xq(1:20:end), Fs/20)  
%wavwrite(xq, 'xq');

%Xi inget ont som inte ha något gott med sig
%Xq väck inte den björn som sover