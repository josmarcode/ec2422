% Funcion que simula el proceso de modulacion
% AM y DSB.
% @param msg: mensaje a modular.
% @param selector_modulacion: 'AM' o 'DSB'.
% @param fc: frecuencia de la portadora.
% @param mu: indice de modulacion.
% @return modulacion: senal modulada.
function [msg] = modulador(msg, selector_modulacion, fc, mu)
    N   = 200000;   % Número de muestras
    fs  = 90000;    % Frecuencia de muestreo
    % Parámetros de tiempo
    t = 0:1/fs:(N-1)/fs;
    
    % Generar la señal portadora
    c_t = cos(2*pi*fc*t);
    
    % Modulación AM
    if strcmp(selector_modulacion, 'AM')
        % Modulación con índice de modulación µ
        msg_mod = (1 + mu * msg) .* c_t;
        % if mu > 1
        %     msg_mod = (1 + mu * msg) .* c_t;
        % else
        %     error('El índice de modulación debe ser mayor a 1 para la modulación AM.');
        % end
    
    % Modulación DSB
    elseif strcmp(selector_modulacion, 'DSB')
        % Generar la señal portadora en banda lateral inferior (BLI)
        bli_t = msg .* c_t;
        
        % Generar la señal portadora en banda lateral superior (BLS)
        bls_t = hilbert(msg) .* sin(2*pi*fc*t);
        
        % Sumar ambas señales portadoras
        msg_mod = bli_t + bls_t;
    
    % Selector de modulación inválido
    else
        error('Selector de modulación inválido. Por favor, elige "AM" o "DSB".');
    end
    
    % Salida de la señal modulada
    msg = msg_mod;
end
