% Funcion que calcula la FFT de una senal y la grafica
% @param x: senal a analizar
% @param fs: frecuencia de muestreo de la senal
% @return X: FFT de la senal
function [X]=fftplot(x,fs)

% Calcula la fft, y corrige el espectro para ver el nivel DC en el Origen
X=fftshift(fft(x));
MX=abs(X); % Se busca el modulo de X
N=length(MX);
MX=MX/N;
f=-fs/2:fs/N:fs/2-fs/N; 
figure;
plot(f,MX); 