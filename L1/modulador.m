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

    % Modulación DSB
    elseif strcmp(selector_modulacion, 'DSB')
        % Modulacion DSB
        msg_mod = msg .* c_t;

    % Selector de modulación inválido
    else
        error('Selector de modulación inválido. Por favor, elige "AM" o "DSB".');
    end
    
    % Salida de la señal modulada
    msg = msg_mod;
end
