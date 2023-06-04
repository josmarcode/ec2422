% Universidad Simon Bolivar
% Lab2 - EC2422 Comunicaciones 1
% Abril Julio 2023
% Autores:
% Josmar Dominguez 16-10315
% Oscar Gonzalez 18-10526

% Se limpia el espacio de trabajo
clc;
clear all
close all

%% == Constantes == %%
N       = 825000;       % Numero de muestras
fs      = 110250;       % Frecuencia de muestreo
fm      = 1500;         % Frecuencia de la senal
am      = 1;            % Amplitud de la senal
fc      = 15000;        % Frecuencia de la portadora
f_if    = 14000;        % Frecuencia intermedia
f_lpf   = 16000;        % Frecuencia de corte del filtro pasabajos

%% == Senal de entrada == %%
sel_signal = input("Ingrese el selector\n1. x(t)\n2. sonido (arch1)\n3. señal compuesta (arch2)\n");
disp("El selector es: " + sel_signal)
msg = mensaje(sel_signal);

% Se grafica la senal de entrada en frecuencia
fftplot(msg, fs);

% Se grafica la senal de entrada en el tiempo
t = linspace(0, N/fs, N);
figure
if sel_signal == 2
    plot(t, msg)
else
    plot(t(1:length(t)/5000), msg(1:length(t)/5000))
end
title("Señal de entrada en el tiempo")
xlabel("Tiempo (s)")
ylabel("Amplitud")

%% == Modulación FM == %%
indices = [1, 2, 5];

% Calculo de frecuencia máxima del mensaje
if sel_signal == 1
    fm_msg = fm;
elseif sel_signal == 2
    f_msg  = fftshift(abs(fft(msg)));
    fm_msg = max(f_msg);
else
    error("No implementado");
end

for i = 1:length(indices)
    indice_modulacion = indices(i);
    s = fmmod(msg, fc, fs, indice_modulacion*fm_msg);

    % Calculo de ancho de banda
    bw = 2 * (indice_modulacion + 1) * fm_msg;

    % Grafica del espectro
    f = (-fs/2:fs/N:fs/2 - fs/N);
    espectro = fftshift(abs(fft(s)));

    figure;
    plot(f, espectro);
    title("Espectro de la señal modulada con indice de modulacion " + indice_modulacion)
    xlabel("Frecuencia (Hz)")
    ylabel("Amplitud")
    grid on;

    fprintf('Ancho de banda (β = %d): %.2f Hz\n', indice_modulacion, bw);
end