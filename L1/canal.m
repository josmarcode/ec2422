% Simula el canal de comunicacion a utilizar.
% Puede ser sin ruido o con ruido blanco gaussiano con cierta potencia
% @param msg_mod: mensaje modulado
% @param selector_ruido: 0 para sin ruido, 1 para con ruido
% @param Pr: potencia del ruido
% @return msg_canal: mensaje modulado con ruido
function [msg_canal] = canal(msg_mod, selector_ruido, Pr)
    % Calcular la potencia de la señal modulada
    Pm = mean(abs(msg_mod).^2);
    
    % Calcular la densidad espectral de potencia del ruido
    No = Pr / 2;
    
    % Simulación del canal sin ruido
    if selector_ruido == 0
        msg_canal = msg_mod;
    
    % Simulación del canal con ruido blanco gaussiano
    elseif selector_ruido == 1
        % Generar ruido blanco gaussiano
        noise = sqrt(No) * randn(size(msg_mod));
        
        % Sumar el ruido a la señal modulada
        msg_canal = msg_mod + noise;
    
    % Selector de ruido inválido
    else
        error('Selector de ruido inválido. Por favor, elige "sin ruido" o "con ruido".');
    end
end
