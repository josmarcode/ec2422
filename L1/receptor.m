% Función que simula el receptor de la comunicación
% con un filtro pasabanda, un detector síncrono y un filtro pasabajo
% @param msg_canal: mensaje recibido por el canal
% @param fase_detector: fase del oscilador local del detector síncrono
% @return y_BPF: señal filtrada por el filtro pasabanda
% @return y_D: señal detectada por el detector síncrono
% @return y_LPF: señal filtrada por el filtro pasabajo
function [y_BPF, y_D, y_LPF] = receptor(msg_canal, fase_detector)
    N   = 200000;   % Número de muestras
    fs  = 90000;    % Frecuencia de muestreo
    fc  = 20000;    % Frecuencia de la portadora

    fC = 20000; % Frecuencia central
    bw = 20000; % Ancho de banda
    
    % Filtro pasabanda (BPF)
    f_bpf   = [fC-bw/2 fC+bw/2]; % Frecuencias de corte del filtro pasabanda
    bpf     = fir1(100, f_bpf/(fs/2));
    
    % Filtro pasabajo (LPF)
    lpf     = fir1(100, bw/(fs/2));
    
    % Filtro pasabanda
    y_BPF   = filter(bpf, 1, msg_canal);
    
    % Detector síncrono
    t       = 0:1/fs:(N-1)/fs;
    y_D     = y_BPF .* cos(2*pi*fc*t + fase_detector);
    
    % Filtro pasabajo
    y_LPF   = filter(lpf, 1, y_D);
end
