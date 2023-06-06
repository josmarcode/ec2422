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
f_lpf   = 2000;         % Frecuencia de corte del filtro pasabajos
t = linspace(0, N/fs, N);

%% == Senal de entrada == %%
sel_signal = input("Ingrese la opción:\n1. Modular x(t)\n2. Modular sonido (arch1)\n3. Demodular señal compuesta (arch2)\n");
disp("El selector es: " + sel_signal)
msg = mensaje(sel_signal);

% Se grafica la senal de entrada en frecuencia

% Se grafica la senal de entrada en el tiempo (si es un mensaje)
if sel_signal == 1
    fftplot(msg, fs);
    figure
    plot(t(1:length(t)/5000), msg(1:length(t)/5000))
    title("Señal de entrada en el tiempo")
    xlabel("Tiempo (s)")
    ylabel("Amplitud")
elseif sel_signal == 2
    fftplot(msg, fs);
    figure
    plot(t, msg)
    title("Señal de entrada en el tiempo")
    xlabel("Tiempo (s)")
    ylabel("Amplitud")
end

%% == Tratamiento según la opción == %%
% Calculo de frecuencia máxima del mensaje
if sel_signal == 1
    indices = [1, 2, 5];
    fm_msg = fm;
elseif sel_signal == 2
    f_msg  = fftshift(abs(fft(msg)));
    fm_msg = max(f_msg);
    indices = [1, 5, 10];
elseif sel_signal == 3
    
    % Pedir frecuencia de estación
    estaciones = [20000, 35000];                % Frecuencias de las estaciones
    sel_estacion = input("Ingrese la frecuencia de la estación:\n 1. RF = 20 kHz\n 2. RF = 35 kHz\n");
    f_LO = estaciones(sel_estacion) + f_if;     % Frecuencia del oscilador local
    
    fftplot(msg, fs);
    %% === RECEPTOR SUPERHETERODINO === %%
    [y_A, y_B, y_C, y_D, y_E] = receptor(msg, f_LO, estaciones(sel_estacion), 2500, 2500);

    %% == Graficar espectro de cada salida == %%
    % f_A = fftshift(abs(fft(y_A)));
    % f_B = fftshift(abs(fft(y_B)));
    % f_C = fftshift(abs(fft(y_C)));
    % f_D = fftshift(abs(fft(y_D)));
    f_E = fftshift(abs(fft(y_E)));

    f = (-fs/2:fs/N:fs/2 - fs/N);

    fftplot(y_A, fs);
    title("Señal a salida de sección RF (" + estaciones(sel_estacion)/1000 + " kHz)")
    xlabel("Frecuencia (Hz)")
    ylabel("Amplitud")

    fftplot(y_B, fs);
    title("Señal mezclada y sintonizada")
    xlabel("Frecuencia (Hz)")
    ylabel("Amplitud")

    fftplot(y_C, fs);
    title("Señal a la salida de sección IF")
    xlabel("Frecuencia (Hz)")
    ylabel("Amplitud")

    fftplot(y_D, fs);
    title("Señal a la salida de detector FM")
    xlabel("Frecuencia (Hz)")
    ylabel("Amplitud")

    % Graficar en frecuencia y en tiempo
    figure;
    subplot(2,1,1)
    plot(t, y_E)
    title("Señal a la salida de filtro pasabajos")
    xlabel("Tiempo (s)")
    ylabel("Amplitud")
    if sel_estacion == 2
        axis([0 8 0.57 0.62]);
    else
        axis([0 8 0.28 0.32])
    end

    subplot(2,1,2)
    plot(f, f_E);
    title("Señal a la salida de filtro pasabajos")
    xlabel("Frecuencia (Hz)")
    ylabel("Amplitud")

    % Reproducir sonido de salida
    sound(y_E, fs);

    % Aplicar ruido y graficar
    Sr_Nr_values = [1, 2, 3, 4, 5];

    [Sd_Nd, Sr_Nr] = ruido(y_E, 0.1, Sr_Nr_values);

    % for i = 1:length(Sr_Nr_values)
    %     Sr_Nr_val = Sr_Nr_values(i);
    %     [Sd_Nd, Sr_Nr] = ruido(y_E, 0.1, Sr_Nr_val);
    % end
    return      % Finalizar programa
end

%% == Modulación == %%
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

