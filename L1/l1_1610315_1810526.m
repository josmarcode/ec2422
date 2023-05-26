% Universidad Simon Bolivar
% Lab1 - EC2422 Comunicaciones 1
% Abril Julio 2023
% Autores:
% Josmar Dominguez 16-10315
% Oscar Gonzalez 18-10526

% Se limpia el espacio de trabajo
clear all
close all

%%  == Constantes == %%
N = 200000; % Numero de muestras
fs = 90000; % Frecuencia de muestreo
fc = 20000; % Frecuencia de la portadora

%% == Lectura de datos == %%
% Se procesa el mensaje según el selector
signals     = ["x(t)", "sonido"];
sel_signal  = input("Ingrese el selector\n1. x(t)\n2. sonido\n");
disp("El selector es: " + signals(sel_signal))
msg = mensaje(signals(sel_signal));

% Se modula el mensaje según el selector
modulations = ["AM", "DSB"];
sel_mod     = input("Ingrese el selector\n1. AM\n2. DSB\n");
disp("El selector es: " + modulations(sel_mod))
% Se pide el indice de modulacion si es AM
mu = 0;
if sel_mod == 1
    mu = input("Ingrese el indice de modulacion\n");
end
msg_mod = modulador(msg, modulations(sel_mod), fc, mu);

% Se agrega ruido a la senal modulada
sel_noise = input("Indique el nivel de ruido (0 o 1)\n");
pr = 0;
if sel_noise == 1
    pr = input("Indique la potencia del ruido\n");
end
msg_canal = canal(msg_mod, sel_noise, pr);

% Se obtiene el proceso del receptor
fase_detector = pi/4;
[y_BPF, y_D, y_LPF] = receptor(msg_canal, fase_detector);

%% == Procesamiento de la senal == %%
% Se crea el vector de tiempo
t = linspace(0, N, N); % Se crea el vector de tiempo

f = linspace(-fs/2, fs/2, length(msg));

% Graficar en el tiempo y en la frecuencia
figure(1)
subplot(2,1,1)
% Graficar en el tiempo y en la frecuencia
if sel_signal == 1
    % Se grafica solo una parte de la senal para que se vea mejor
    plot(t(1:length(t)/1000), msg(1:length(t)/1000))
else
    % Se grafica todo el ruido
    plot(t, msg)
end
title("x(t) en el tiempo")
xlabel("Tiempo [s]")
ylabel("Amplitud")
subplot(2,1,2)
plot(f, fftshift(abs(fft(msg))))
title("x(t) en la frecuencia")
xlabel("Frecuencia [Hz]")
ylabel("Amplitud")
grid on

%% == Modulacion de la senal == %%
% Graficar el espectro a la salida del transmisor
figure(2)
subplot(2,1,1)
% Graficar en el tiempo y en la frecuencia
if sel_signal == 1
    % Se grafica solo una parte de la senal para que se vea mejor
    plot(t(1:length(t)/1000), msg_mod(1:length(t)/1000))
else
    % Se grafica todo el ruido
    plot(t, msg_mod)
end
title("x(t) modulada (" + modulations(sel_mod) + ") en el tiempo")
xlabel("Tiempo [s]")
ylabel("Amplitud")
subplot(2,1,2)
plot(f, fftshift(abs(fft(msg_mod))))
title("x(t) modulada en la frecuencia")
xlabel("Frecuencia [Hz]")
ylabel("Amplitud")
grid on

%% == Agregado de ruido == %%
% Graficar el espectro a la salida del transmisor
if sel_noise == 1
    figure(3)
    subplot(2,1,1)
    % Graficar en el tiempo y en la frecuencia
    if sel_signal == 1
        % Se grafica solo una parte de la senal para que se vea mejor
        plot(t(1:length(t)/1000), msg_canal(1:length(t)/1000))
    else
        % Se grafica todo el ruido
        plot(t, msg_canal)
    end
    title("x(t) modulada con ruido en el tiempo")
    xlabel("Tiempo [s]")
    ylabel("Amplitud")
    subplot(2,1,2)
    plot(f, fftshift(abs(fft(msg_canal))))
    title("x(t) modulada con ruido en la frecuencia")
    xlabel("Frecuencia [Hz]")
    ylabel("Amplitud")
    grid on
end

%% == Recepción de la señal == %%
% Graficar el espectro de las salidas del receptor
figure(4)
% -- Filtro pasabanda --
subplot(3,2,1)
% Graficar en el tiempo y en la frecuencia
if sel_signal == 1
    % Se grafica solo una parte de la senal para que se vea mejor
    plot(t(1:length(t)/1000), y_BPF(1:length(t)/1000))
else
    % Se grafica toda la senal
    plot(t, y_BPF)
end
title("y_{BPF}(t) en el tiempo")
xlabel("Tiempo [s]")
ylabel("Amplitud")
subplot(3,2,2)
plot(f, fftshift(abs(fft(y_BPF))))
title("y_{BPF}(t) en la frecuencia")
xlabel("Frecuencia [Hz]")
ylabel("Amplitud")
grid on
% -- Detector síncrono --
subplot(3,2,3)
% Graficar en el tiempo y en la frecuencia
if sel_signal == 1
    % Se grafica solo una parte de la senal para que se vea mejor
    plot(t(1:length(t)/1000), y_D(1:length(t)/1000))
else
    % Se grafica todo el ruido
    plot(t, y_D)
end
title("y_D(t) en el tiempo")
xlabel("Tiempo [s]")
ylabel("Amplitud")
subplot(3,2,4)
plot(f, fftshift(abs(fft(y_D))))
title("y_D(t) en la frecuencia")
xlabel("Frecuencia [Hz]")
ylabel("Amplitud")
grid on
% -- Filtro pasabajos --
subplot(3,2,5)
% Graficar en el tiempo y en la frecuencia
if sel_signal == 1
    % Se grafica solo una parte de la senal para que se vea mejor
    plot(t(1:length(t)/1000), y_LPF(1:length(t)/1000))
else
    % Se grafica todo el ruido
    plot(t, y_LPF)
end
title("y_{LPF}(t) en el tiempo")
xlabel("Tiempo [s]")
ylabel("Amplitud")
subplot(3,2,6)
plot(f, fftshift(abs(fft(y_LPF))))
title("y_{LPF}(t) en la frecuencia")
xlabel("Frecuencia [Hz]")
ylabel("Amplitud")
grid on
