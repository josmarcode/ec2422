% Función que simula el superheterodino
% y demodula la señal x(t)
% @param msg_RF: Frecuencia de sintonización
% @param f_LO: Frecuencia del oscilador local
% @param freqDev: Desviación de frecuencia
% @param w_IF: Ancho del filtro pasabanda de IF
% @param w: Ancho del mensaje original
% @return y_A: Señal mezclada en el punto A
% @return y_B: Señal del oscilador local en el punto B
% @return y_C: Salida de la sección IF
% @return y_D: Señal del detector FM
% @return y_E: Señal recuperada
function [y_A, y_B, y_C, y_D, y_E] = receptor(msg_RF, f_LO, freqDev, w_IF, w)
    % % Parámetros de la señal
    N       = 825000;       % Numero de muestras
    fs      = 110250;       % Frecuencia de muestreo
    f_if    = 14000;        % Frecuencia intermedia
    f_lpf   = 2000;         % Frecuencia de corte del filtro pasabajos
    w_rf    = 5500;         % Ancho de banda de la señal RF
    
    % Sección RF: Filtrar segun la frecuencia de sintonización
    fc      = f_LO - f_if;                      % Frecuencia central
    f_rf    = [fc-w_rf/2, fc+w_rf/2];           % Frecuencias de corte del filtro
    b_rf    = fir1(64, f_rf/(fs/2));            % Diseño del filtro FIR
    y_A     = filter(b_rf, 1, msg_RF);          % Salida de la sección RF
    
    % Oscilador local, sintonización y mezcla
    t   = (0:N-1)/fs;           % Vector de tiempos
    LO  = cos(2*pi*f_LO*t);     % Oscilador local
    y_B = y_A .* LO;            % Señal mezclada con el oscilador local
    
    % Sección IF (Filtro pasabanda)
    f_fif       = [f_if-w_IF/2, f_if+w_IF/2];        % Frecuencias de corte del filtro
    b           = fir1(64, f_fif/(fs/2));      % Diseño del filtro FIR
    y_C         = filter(b, 1, y_A);                % Salida de la sección IF
    
    % Detector FM
    y_D = fmdemod(y_C, f_if, fs, freqDev);  % Señal demodulada en el punto D
    
    % LPF (Filtro pasabajos)
    b           = fir1(64, f_lpf/(fs/2));   % Diseño del filtro FIR
    y_E         = filter(b, 1, y_D);        % Salida del filtro pasabajos (señal demodulada en el punto E)

end
