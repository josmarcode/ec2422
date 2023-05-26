% Funcion que devuelve el mensaje a procesar
% con el formato adecuado para la simulacion
% @param selector: 'x(t)' o 'sonido'
% @return msg: mensaje a procesar
function [msg] = mensaje(selector)
    N   = 200000;   % Número de muestras
    fs  = 90000;    % Frecuencia de muestreo

    % Cargar el archivo1.mat que contiene el sonido
    load('archivo1.mat');
    
    % Definir la señal x(t) proporcionada
    t = 0:1/fs:(N-1)/fs;
    x_t = 0.50*cos(2*pi*10000*t) + cos(2*pi*5000*t) + 2*cos(2*pi*2500*t);
    
    % Seleccionar el mensaje a procesar
    if strcmp(selector, 'x(t)')
        msg = x_t;
    elseif strcmp(selector, 'sonido')
        msg = sonido;
    else
        error('Selector de mensaje inválido. Por favor, elige "x(t)" o "sonido".');
    end

    % Ajustar la amplitud máxima a 1
    msg = msg / max(abs(msg));

    % Eliminar el nivel DC
    msg = msg - mean(msg);

    % Redimensionar el mensaje al número de muestras apropiado
    msg = interp1(1:length(msg), msg, linspace(1, length(msg), N));
end
