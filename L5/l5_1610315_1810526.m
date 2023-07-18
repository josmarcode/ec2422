% Universidad Simon Bolivar
% Lab5 - EC2422 Comunicaciones 1
% Abril Julio 2023
% Autores:
% Josmar Dominguez 16-10315
% Oscar Gonzalez 18-10526

% Se limpia la pantalla, se borran todas las variables y se cierran todas las
% las figuras
clear all;
close all;
clc;

%% == CUANTIFICACIÓN DEL SENO ==

% == 1. Cuantificación uniforme ==
% Parámetros dados
a           = 1;            % Amplitud del seno (1V)
f           = 1;            % Frecuencia del seno (1Hz)
fs          = 100;          % Frecuencia de muestreo (100Hz)
nmin = 2;               % Número inicial de bits para cuantificación   
nmax = 4;               % Número final de bits para cuantificación
range       = 2 * a;        % Rango de la señal

for n = nmin:nmax
    disp('== CUANTIFICACIÓN CON ' + string(n) + ' BITS ==');

    q_step = range / (2^n);     % Paso de cuantificación

    % Generar señal seno
    t = 0:1/fs:2;                       % Vector de tiempo para dos segundos
    sine = a * sin(2*pi*f*t);     % Señal seno

    % Cuantificación uniforme
    senal_cuantizada = round(sine / q_step) * q_step;

    % Calcular el error de cuantificación
    error_cuantizacion = senal_cuantizada - sine;

    % Graficar las señales y el error
    figure;

    % Gráfico de la señal original y cuantizada en el dominio del tiempo
    subplot(3, 1, 1);
    plot(t, sine, 'b', 'LineWidth', 1.5);
    hold on;
    plot(t, senal_cuantizada, 'r', 'LineWidth', 1.5);
    xlabel('Tiempo (segundos)');
    ylabel('Amplitud (V)');
    legend('Señal original', 'Señal cuantizada');
    title('Señal Original y Cuantizada (' + string(n) + ' bits)');

    % Gráfico del error de cuantificación en el dominio del tiempo
    subplot(3, 1, 2);
    plot(t, error_cuantizacion, 'g', 'LineWidth', 1.5);
    xlabel('Tiempo (segundos)');
    ylabel('Error de cuantización (V)');
    title('Error de Cuantización');

    % Gráfico del espectro de frecuencia de la señal original y cuantizada
    subplot(3, 1, 3);
    fft_senal_original = fftshift(abs(fft(sine)));
    fft_senal_cuantizada = fftshift(abs(fft(senal_cuantizada)));
    f_vec = linspace(-fs/2, fs/2, length(fft_senal_original));
    plot(f_vec, fft_senal_original, 'b', 'LineWidth', 1.5);
    hold on;
    plot(f_vec, fft_senal_cuantizada, 'r', 'LineWidth', 1.5);
    xlabel('Frecuencia (Hz)');
    ylabel('Amplitud');
    legend('Espectro de la señal original', 'Espectro de la señal cuantizada');
    title('Espectro de frecuencia');

    % Ajustar el tamaño de la figura
    set(gcf, 'Position', [100, 100, 800, 600]);


    % == 2. Histogramas superpuestos de las señales ==
    figure;

    % Histograma de la señal original
    histogram(sine, 20, 'FaceColor', 'b', 'EdgeColor', 'none');
    hold on;

    % Histograma de la señal cuantizada
    histogram(senal_cuantizada, 20, 'FaceColor', 'r', 'EdgeColor', 'none');

    % Histograma del error de cuantificación
    histogram(error_cuantizacion, 20, 'FaceColor', 'g', 'EdgeColor', 'none');

    xlabel('Amplitud (V)');
    ylabel('Número de muestras');
    legend('Señal original', 'Señal cuantizada');
    title('Histogramas de las señales (' + string(n) + ' bits)');

    % Ajustar el tamaño de la figura
    set(gcf, 'Position', [100, 100, 800, 600]);

    % == 3. Calculo de la relación señal/ruido de la cuantificación ==
    % Potencia de la señal original
    p_original = sum(sine.^2) / length(sine);

    % Potencia del error de cuantificación
    p_error = sum(error_cuantizacion.^2) / length(error_cuantizacion);

    % Relación señal/ruido de la cuantificación
    rsrc = p_original / p_error;

    disp('Relación señal/ruido de la cuantificación:');
    disp(rsrc);

end

%% == CUANTIFICACIÓN DE LA SEÑAL DE VOZ ==
n_bits = [4, 6];       % Número de bits para cuantificación

% == 1. Cuantificación uniforme ==
% Parámetros dados
fs = 8000;          % Frecuencia de muestreo (8kHz)
range = 2;          % Rango de la señal

% Leer el archivo de audio (prueba.wav)
[voz, fs] = audioread('prueba.wav');

% Cuantificación uniforme
voice_cuantizada = zeros(length(n_bits), length(voz));
for i = 1:length(n_bits)
    q_step = range / (2^n_bits(i));     % Paso de cuantificación
    voice_cuantizada(i, :) = round(voz / q_step) * q_step;
end

% Calcular el error de cuantificación
error_cuantizacion = zeros(length(n_bits), length(voz));
for i = 1:length(n_bits)
    % Transponer la señal para que sea un vector columna
    error_cuantizacion(i, :) = voice_cuantizada(i, :) - voz';
end

% == 1.1 Graficar curva entrada vs salida del cuantificador para 4 bits ==
figure;
stairs(voz, voice_cuantizada(1, :), 'LineWidth', 1.5);
xlabel('Entrada');
ylabel('Salida');
title('Curva entrada vs salida del cuantificador (4 bits)');
set(gcf, 'Position', [100, 100, 800, 600]);



for i = 1:length(n_bits)
    % Graficar las señales y el error
    figure;

    % Gráfico de la señal original y cuantizada en el dominio del tiempo
    subplot(3, 1, 1);
    plot(voz, 'b', 'LineWidth', 1.5);
    hold on;
    plot(voice_cuantizada(i, :), 'r', 'LineWidth', 1.5);
    xlabel('Tiempo (segundos)');
    ylabel('Amplitud (V)');
    legend('Señal original', 'Señal cuantizada');
    title('Señal Original y Cuantizada (' + string(n_bits(i)) + ' bits)');

    % Gráfico del error de cuantificación en el dominio del tiempo
    subplot(3, 1, 2);
    plot(error_cuantizacion(i, :), 'g', 'LineWidth', 1.5);
    xlabel('Tiempo (segundos)');
    ylabel('Error de cuantización (V)');
    title('Error de Cuantización');

    % Gráfico del espectro de frecuencia de la señal original y cuantizada
    subplot(3, 1, 3);
    fft_senal_original = fftshift(abs(fft(voz)));
    fft_senal_cuantizada = fftshift(abs(fft(voice_cuantizada(1, :))));
    f_vec = linspace(-fs/2, fs/2, length(fft_senal_original));
    plot(f_vec, fft_senal_original, 'b', 'LineWidth', 1.5);
    hold on;
    plot(f_vec, fft_senal_cuantizada, 'r', 'LineWidth', 1.5);
    xlabel('Frecuencia (Hz)');
    ylabel('Amplitud');
    legend('Espectro de la señal original', 'Espectro de la señal cuantizada');
    title('Espectro de frecuencia');

    % Ajustar el tamaño de la figura
    set(gcf, 'Position', [100, 100, 800, 600]);
    
    
    % == 2. Guardar las señales cuantizadas ==
    audiowrite(sprintf('prueba_%d.wav', n_bits(i)), voice_cuantizada(i, :), fs);

    % == 4. Mostrar los histogramas de las señales ==
    figure;

    % Histograma de la señal original
    histogram(voz, 20, 'FaceColor', 'b', 'EdgeColor', 'none');
    hold on;

    % Histograma de la señal cuantizada
    histogram(voice_cuantizada(i, :), 20, 'FaceColor', 'r', 'EdgeColor', 'none');

    % Histograma del error de cuantificación
    histogram(error_cuantizacion(i, :), 20, 'FaceColor', 'g', 'EdgeColor', 'none');

    xlabel('Amplitud (V)');
    ylabel('Número de muestras');
    legend('Señal original', 'Señal cuantizada');
    title('Histogramas de las señales (' + string(n_bits(i)) + ' bits)');

    % == 5. Mostrar la relación señal/ruido de la cuantificación ==
    % Potencia de la señal original
    p_voz = sum(voz.^2) / length(voz);

    % Potencia del error de cuantificación
    p_error_voz = sum(error_cuantizacion(i, :).^2) / length(error_cuantizacion(i, :));

    % Relación señal/ruido de la cuantificación
    rsrc_voz = p_voz / p_error_voz;

    disp('Relación señal/ruido de la cuantificación (' + string(n_bits(i)) + ' bits):');
    disp(rsrc_voz);
end

%% == CUANTIFICACIÓN NO UNIFORME DE SEÑAL DE VOZ ==
% Parámetros
mu = 255;               % Parámetro mu
n_bits_nu = [4, 6];     % Número de bits para cuantificación
xmax = max(voz);   % Valor máximo de la señal

% == 1. Cuantificación no uniforme ==
% Cuantificación no uniforme
voice_nu = (xmax .* log(1 + mu * abs(voz/xmax)) / log(1 + mu)) .* sign(voz);

% Cuantizar voice_nu a 4 y 6 bits
voice_cuantizada_nu = zeros(length(n_bits_nu), length(voz));
for i = 1:length(n_bits_nu)
    q_step = range / (2^n_bits_nu(i));     % Paso de cuantificación
    voice_cuantizada_nu(i, :) = round(voice_nu / q_step) * q_step;
end

% == 2. Curva entrada vs salida del cuantificador para 4 bits ==
figure;
stairs(voz, voice_cuantizada_nu(1, :), 'LineWidth', 1.5);
xlabel('Entrada');
ylabel('Salida');
title('Curva entrada vs salida del cuantificador no-uniforme (4 bits)');
set(gcf, 'Position', [100, 100, 800, 600]);

% == 3. Graficar señales y error ==
for i = 1:length(n_bits)
    % Graficar las señales y el error
    figure;

    % Gráfico de la señal original y cuantizada en el dominio del tiempo
    subplot(3, 1, 1);
    plot(voz, 'b', 'LineWidth', 1.5);
    hold on;
    plot(voice_cuantizada_nu(i, :), 'r', 'LineWidth', 1.5);
    xlabel('Tiempo (segundos)');
    ylabel('Amplitud (V)');
    legend('Señal original', 'Señal cuantizada');
    title('Señal Original y Cuantizada no-uniforme (' + string(n_bits(i)) + ' bits)');

    % Gráfico del error de cuantificación en el dominio del tiempo
    subplot(3, 1, 2);
    plot(error_cuantizacion(i, :), 'g', 'LineWidth', 1.5);
    xlabel('Tiempo (segundos)');
    ylabel('Error de cuantización (V)');
    title('Error de Cuantización');

    % Gráfico del espectro de frecuencia de la señal original y cuantizada
    subplot(3, 1, 3);
    fft_senal_original = fftshift(abs(fft(voz)));
    fft_senal_cuantizada = fftshift(abs(fft(voice_cuantizada_nu(1, :))));
    f_vec = linspace(-fs/2, fs/2, length(fft_senal_original));
    plot(f_vec, fft_senal_original, 'b', 'LineWidth', 1.5);
    hold on;
    plot(f_vec, fft_senal_cuantizada, 'r', 'LineWidth', 1.5);
    xlabel('Frecuencia (Hz)');
    ylabel('Amplitud');
    legend('Espectro de la señal original', 'Espectro de la señal cuantizada');
    title('Espectro de frecuencia');

    % Ajustar el tamaño de la figura
    set(gcf, 'Position', [100, 100, 800, 600]);
    
    
    % == 2. Guardar las señales cuantizadas ==
    audiowrite(sprintf('prueba_nu_%d.wav', n_bits(i)), voice_cuantizada_nu(i, :), fs);

    % == 4. Mostrar los histogramas de las señales ==
    figure;

    % Histograma de la señal original
    histogram(voz, 20, 'FaceColor', 'b', 'EdgeColor', 'none');
    hold on;

    % Histograma de la señal cuantizada
    histogram(voice_cuantizada_nu(i, :), 20, 'FaceColor', 'r', 'EdgeColor', 'none');

    % Histograma del error de cuantificación
    histogram(error_cuantizacion(i, :), 20, 'FaceColor', 'g', 'EdgeColor', 'none');

    xlabel('Amplitud (V)');
    ylabel('Número de muestras');
    legend('Señal original', 'Señal cuantizada');
    title('Histogramas de las señales no-uniforme (' + string(n_bits(i)) + ' bits)');

    % == 5. Mostrar la relación señal/ruido de la cuantificación ==
    % Potencia de la señal original
    p_voz = sum(voz.^2) / length(voz);

    % Potencia del error de cuantificación
    p_error_voz = sum(error_cuantizacion(i, :).^2) / length(error_cuantizacion(i, :));

    % Relación señal/ruido de la cuantificación
    rsrc_voz = p_voz / p_error_voz;

    disp('Relación señal/ruido de la cuantificación no-uniforme (' + string(n_bits(i)) + ' bits):');
    disp(rsrc_voz);
end