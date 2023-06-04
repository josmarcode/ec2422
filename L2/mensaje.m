% Funcion que devuelve el mensaje a procesar
% con el formato adecuado para la simulacion
% @param selector: entero que indica el mensaje a procesar
% @return msg: mensaje a procesar
function [msg] = mensaje(selector)
    N   = 825000;       % Numero de muestras
    fs  = 110250;       % Frecuencia de muestreo
    fm  = 1500;        % Frecuencia de la senal
    am  = 1;            % Amplitud de la senal  
    
    % Definir el tono x(t)
    t = 0:1/fs:(N-1)/fs;
    x_t = am * cos(2*pi*fm*t);
    
    % Seleccionar el mensaje a procesar
    if selector == 1
        msg = x_t;
    elseif selector == 2
        load('arch1.mat');
        msg = msg1;
    elseif selector == 3
        load('arch2.mat');
        msg = y_rf_tot;
    else
        error('Selector de mensaje no válido');
    end

    % % Ajustar la amplitud máxima a 1
    % msg = msg / max(abs(msg));

    % % Eliminar el nivel DC
    % msg = msg - mean(msg);

    % % Redimensionar el mensaje al número de muestras apropiado
    % msg = interp1(1:length(msg), msg, linspace(1, length(msg), N));
end
