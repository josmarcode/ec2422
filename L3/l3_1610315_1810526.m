% Universidad Simon Bolivar
% Lab3 - EC2422 Comunicaciones 1
% Abril Julio 2023
% Autores:
% Josmar Dominguez 16-10315
% Oscar Gonzalez 18-10526

% Se limpia el espacio de trabajo
clc;
clear all
close all

%% == 3.3 Señales básicas == %%
% == 3.3.1 Señal sinusoidal == %
fs  = 10e6;                 % Frecuencia de muestreo
N   = 20e6;                 % Número de muestras
f   = (-N/2:N/2-1)*fs/N;    % Eje de frecuencia
t   = 0:1/fs:(N-1)/fs;      % Eje de tiempo
fm  = 1e6;                  % Frecuencia de la señal
a   = 1;                    % Amplitud

sinusoidal = a*cos(2*pi*fm*t);  % Señal sinusoidal

% Cálculo del espectro de magnitud
sinusoidal_fft = fftshift(abs(fft(sinusoidal)));

% Grafica de los espectros
figure(1)
subplot(2,1,1)
plot(t,sinusoidal, 'LineWidth', 2)
title('Señal sinusoidal')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 10/fm])
subplot(2,1,2)
plot(f,sinusoidal_fft, 'LineWidth', 2)
title('Espectro de la señal sinusoidal')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')
xlim([-2*fm 2*fm])

% == 3.3.2 Señal cuadrada == %
a = 1;                  % Amplitud
t0 = 1e-6;              % Periodo
dt = 0.5;               % Duty cycle
cuadrada = a*square(2*pi/t0 * t,dt*100);

% Espectro de la señal cuadrada
cuadrada_fft = fftshift(abs(fft(cuadrada)));
% f_cuadrada = linspace(0,1/t0,length(cuadrada_fft));

% Grafica de los espectros
figure(2)
subplot(2,1,1)
plot(t,cuadrada, 'LineWidth', 2)
title('Señal cuadrada')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 10*t0])
subplot(2,1,2)
plot(f, cuadrada_fft, 'LineWidth', 2)
title('Espectro de la señal cuadrada')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')

% Cálculo de los primeros 3 armónicos con coeficientes de Fourier
primer_arm  = 4*a/pi;
segunda_arm = 4*a/(3*pi);
tercer_arm  = 4*a/(5*pi);

% Impresión de los resultados
fprintf('Amplitud de las tres primeras armónicas de SEÑAL CUADRADA:\n');
fprintf('Primer armónica: %.4f\n', primer_arm);
fprintf('Segunda armónica: %.4f\n', segunda_arm);
fprintf('Tercer armónica: %.4f\n', tercer_arm);

% == 3.3.3 Señal triangular == %
a = 1;                  % Amplitud
t0 = 1e-6;              % Periodo

triangular = a*sawtooth(2*pi/t0 * t);

% Espectro de la señal triangular
triangular_fft = fftshift(abs(fft(triangular)));

% Grafica de los espectros
figure(3)
subplot(2,1,1)
plot(t,triangular, 'LineWidth', 2)
title('Señal triangular')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 10*t0])
subplot(2,1,2)
plot(f, triangular_fft, 'LineWidth', 2)
title('Espectro de la señal triangular')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')
xlim([-2*fm 2*fm])

% Cálculo de los primeros 3 armónicos con coeficientes de Fourier
primer_arm  = 2*a/pi;
segunda_arm = 2*a/(3*pi);
tercer_arm  = 2*a/(5*pi);

% Impresión de los resultados
fprintf('Amplitud de las tres primeras armónicas de SEÑAL TRIANGULAR:\n');
fprintf('Primer armónica: %.4f\n', primer_arm);
fprintf('Segunda armónica: %.4f\n', segunda_arm);
fprintf('Tercer armónica: %.4f\n', tercer_arm);

%% == 3.4 Modulación AM == %%
fs2 = 100e6;                 % Frecuencia de muestreo
f2  = (-N/2:N/2-1)*fs2/N;    % Eje de frecuencia
t2  = 0:1/fs2:(N-1)/fs2;      % Eje de tiempo
fc = 50e6;                 % Frecuencia de la portadora
mu = 1;                    % Índice de modulación
ct = cos(2*pi*fc*t2);       % Señal portadora

sin_mod = (1 + mu * sinusoidal) .* ct; % Señal modulada

% Espectro de la señal modulada
sin_mod_fft = fftshift(abs(fft(sin_mod)));

% Grafica del espectro
figure(4)
subplot(3, 1, 1)
plot(t2, sinusoidal, 'LineWidth', 2)
title('Señal sinusoidal')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 1/fm])
subplot(3, 1, 2)
plot(t2, sin_mod, 'LineWidth', 2)
title('Señal modulada')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 1/fm])
subplot(3, 1, 3)
plot(f2, sin_mod_fft, 'LineWidth', 2)
title('Espectro de la señal modulada')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')
xlim([-2*fc 2*fc])

%% == 3.5 Modulación FM == %%
fs3 = 100e6;                % Frecuencia de muestreo
f3  = (-N/2:N/2-1)*fs3/N;   % Eje de frecuencia
t3  = 0:1/fs3:(N-1)/fs3;    % Eje de tiempo
fc = 50e6;                  % Frecuencia de la portadora
ct = cos(2*pi*fc*t3);       % Señal portadora

betas = [0.5 1 2];          % Índices de modulación
fm = 1e6;                   % Frecuencia de la señal moduladora

% Señales moduladas
sin_mod1 = cos(2*pi*fc*t3 + betas(1)*sin(2*pi*fm*t3));
sin_mod2 = cos(2*pi*fc*t3 + betas(2)*sin(2*pi*fm*t3));
sin_mod3 = cos(2*pi*fc*t3 + betas(3)*sin(2*pi*fm*t3));

% Espectro de las señales moduladas
sin_mod1_fft = fftshift(abs(fft(sin_mod1)));
sin_mod2_fft = fftshift(abs(fft(sin_mod2)));
sin_mod3_fft = fftshift(abs(fft(sin_mod3)));

% Grafica del espectro
figure(5)
subplot(3, 2, 1)
plot(t3, sin_mod1, 'LineWidth', 2)
title('Señal modulada con \beta = 0.5')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 1/fm])
subplot(3, 2, 2)
plot(f3, sin_mod1_fft, 'LineWidth', 2)
title('Espectro de la señal modulada con \beta = 0.5')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')
xlim([-2*fc 2*fc])
subplot(3, 2, 3)
plot(t3, sin_mod2, 'LineWidth', 2)
title('Señal modulada con \beta = 1')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 1/fm])
subplot(3, 2, 4)
plot(f3, sin_mod2_fft, 'LineWidth', 2)
title('Espectro de la señal modulada con \beta = 1')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')
xlim([-2*fc 2*fc])
subplot(3, 2, 5)
plot(t3, sin_mod3, 'LineWidth', 2)
title('Señal modulada con \beta = 2')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 1/fm])
subplot(3, 2, 6)
plot(f3, sin_mod3_fft, 'LineWidth', 2)
title('Espectro de la señal modulada con \beta = 2')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')
xlim([-2*fc 2*fc])

%% == 3.6 Aplicar filtro rechaza banda == %%

% Filtro rechaza banda
f1 = 49.5e6;                % Frecuencia de corte inferior
f2 = 50.5e6;                % Frecuencia de corte superior

% Señales filtradas
sin_mod1_filtrada = bandstop(sin_mod1, [f1 f2], fs3);
sin_mod2_filtrada = bandstop(sin_mod2, [f1 f2], fs3);
sin_mod3_filtrada = bandstop(sin_mod3, [f1 f2], fs3);

% Espectro de las señales filtradas
sin_mod1_filtrada_fft = fftshift(abs(fft(sin_mod1_filtrada)));
sin_mod2_filtrada_fft = fftshift(abs(fft(sin_mod2_filtrada)));
sin_mod3_filtrada_fft = fftshift(abs(fft(sin_mod3_filtrada)));

% Grafica del espectro
figure(6)
subplot(3, 2, 1)
plot(t3, sin_mod1_filtrada, 'LineWidth', 2)
title('Señal modulada con \beta = 0.5 filtrada')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 1/fm])
subplot(3, 2, 2)
plot(f3, sin_mod1_filtrada_fft, 'LineWidth', 2)
title('Espectro de la señal modulada con \beta = 0.5 filtrada')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')
xlim([-2*fc 2*fc])
subplot(3, 2, 3)
plot(t3, sin_mod2_filtrada, 'LineWidth', 2)
title('Señal modulada con \beta = 1 filtrada')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 1/fm])
subplot(3, 2, 4)
plot(f3, sin_mod2_filtrada_fft, 'LineWidth', 2)
title('Espectro de la señal modulada con \beta = 1 filtrada')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')
xlim([-2*fc 2*fc])
subplot(3, 2, 5)
plot(t3, sin_mod3_filtrada, 'LineWidth', 2)
title('Señal modulada con \beta = 2 filtrada')
xlabel('Tiempo (s)')
ylabel('Amplitud (V)')
xlim([0 1/fm])
subplot(3, 2, 6)
plot(f3, sin_mod3_filtrada_fft, 'LineWidth', 2)
title('Espectro de la señal modulada con \beta = 2 filtrada')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud (V)')
xlim([-2*fc 2*fc])
