function [Sd_Nd, Sr_Nr] = ruido(msg, Pr, Sr_Nr_values)
    % Geenerar ruido blanco gaussiano
    % Calcular la densidad espectral de potencia del ruido
    No = Pr / 2;
    % Generar ruido blanco gaussiano
    noise = sqrt(No) * randn(size(msg));
    
    % Parámetros
    num_samples = length(msg);  % Número de muestras de la señal
    
    % Inicializar vectores para los resultados
    Sd_Nd = zeros(size(Sr_Nr_values));  % Cociente de potencia señal a ruido a la salida del receptor
    Sr_Nr = zeros(size(Sr_Nr_values));  % Cociente de potencia señal a ruido a la señal recibida
    
    % Calcular los cocientes de potencia señal-ruido
    for i = 1:length(Sr_Nr_values)
        % Calcular las potencias de señal y ruido
        Sr_Nr_value = Sr_Nr_values(i);
        P_signal = var(msg);  % Potencia de la señal
        P_noise = var(noise) / Sr_Nr_value;  % Potencia del ruido
        
        % Calcular los cocientes de potencia señal-ruido
        Sd_Nd(i) = P_signal / P_noise;                     % Cociente de potencia señal a ruido a la salida del receptor
        Sr_Nr(i) = P_signal / (P_noise * Sr_Nr_value);     % Cociente de potencia señal a ruido a la señal recibida

    end
    
    % Graficar Sd/Nd vs Sr/Nr
    figure;
    plot(Sr_Nr, Sd_Nd, 'o-');
    title('Cociente de Potencia Señal-Ruido (Sd/Nd) vs Señal-Ruido (Sr/Nr)');
    xlabel('Sr/Nr');
    ylabel('Sd/Nd');
end
