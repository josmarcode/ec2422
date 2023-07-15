% Universidad Simon Bolivar
% Lab4 - EC2422 Comunicaciones 1
% Abril Julio 2023
% Autores:
% Josmar Dominguez 16-10315
% Oscar Gonzalez 18-10526

% Se limpia la pantalla, se borran todas las variables y se cierran todas las
% las figuras
clear all;
close all;
clc;

%% == Personalizacion de la simulacion == %%
C1=10315; % Primer numero de carnet
C2=10526; % Segundo numero de carnet

%% Parametros basicos e inicializacion de variables %%
rand('state',C1); randn('state',C2);    % Inicializacion de los generadores seudoaleatorios
NBIT=5000;                              % Numero de bits a simular (entero)
% m=6;                                    % Longitud del bloque (run_length)
SECF='Secuencia Fuente: ';
SECC='Secuencia Codigo: ';
P0_range = 0:0.05:1;                 % Rango de probabilidades de ceros

tipo_codigo=input('Codigo a simular? A=Huffman B=run_length ','s');


switch tipo_codigo

    case {'a', 'A'}
        %% == Parametros para graficar == %%
        zero_count      = zeros(size(P0_range));    % Vector para guardar el numero de ceros
        NC_values       = zeros(size(P0_range));    % Vector para guardar los valores de NC
        entropy_values  = zeros(size(P0_range));    % Vector para guardar los valores de la entropia

        %% == Configuracion de la fuente y el codigo == %%
        fuente={'000' '001' '010' '011' '100' '101' '110' '111'};	    % contiene 2^LH strings con todas las palabras binarias de LH bits 
        codigo={'0' '100' '101' '110' '11100' '11101' '11110' '11111'}; % mapeo del Codigo Huffman
        % fuente={'0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111',...
        %         '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111'};	    % contiene 2^LH strings con todas las palabras binarias de LH bits
        % codigo={'00', '100', '101', '110', '111', '01000', '01001', '01010',...
        %          '01011', '01100', '01101', '011101', '011110', '011111', '011000', '011001'}

        LH=length(char(fuente(1)));                                     %longitud de la palabra binaria fuente (Huffman)

        NBLOQ=ceil(NBIT/LH); % numero de bloques a simular

        %% == Simulacion: iterar para cada valor de P0 == %%

        for i = 1:length(P0_range)
            NBC=0;
            P0 = P0_range(i);
            zero_c = 0; % Numero de ceros en la secuencia de bits
            for j = 1:NBLOQ
                % Generacion del caudal de bits
                TBIT = floor(rand+(1-P0)); TBLOQ = num2str(TBIT);
                for k = 2:LH
                    TBIT = floor(rand+(1-P0)); TBLOQ = strcat(TBLOQ,num2str(TBIT));
                end

                %%%% Codificador Huffman
                indice=strmatch(TBLOQ,fuente);
                CBLOQ=codigo(indice);

                %%%% Conteo de bits codificados
                NBC=NBC+length(char(CBLOQ));

                % Conteo de ceros
                zero_c = zero_c + length(find(TBLOQ == '0'));
            end

            Tasa_Compresion=NBLOQ*LH/NBC;
            Bits_P=1/Tasa_Compresion;
            NC_values(i) = Bits_P;
            zero_count(i) = zero_c;

            % Calcular entropia basado en el tamano de la fuente
            entropy_values(i) = calcularEntropia(LH, P0);
            disp(i);
        end

        %% == Graficas == %%
        figure(1)
        plot(P0_range,zero_count,'b')
        title('Numero de ceros en la secuencia de bits')
        xlabel('Probabilidad de ceros')
        ylabel('Numero de ceros')

        figure(2)
        plot(P0_range,entropy_values,'r')
        hold on
        plot(P0_range,NC_values,'g')
        title('Entropia/NC de la fuente Huffman')
        xlabel('Probabilidad de ceros')
        ylabel('Entropia/NC')
        legend('Entropia','NC')

        % figure(3)
        % plot(P0_range,NC_values,'g')
        % title('Tasa de codificación')
        % xlabel('Probabilidad de ceros')
        % ylabel('Bits codificados por cada bit fuente')

    case {'b', 'B'}
        %% == Parametros para graficar == %%
        zero_count      = zeros(size(P0_range));    % Vector para guardar el numero de ceros
        NC_values       = zeros(size(P0_range));    % Vector para guardar los valores de NC
        entropy_values  = zeros(size(P0_range));    % Vector para guardar los valores de la entropia
        
        m_arr = [2, 3, 4, 5, 6];
        NC_matrix = zeros(length(m_arr), length(P0_range));
        entropy_matrix = zeros(length(m_arr), length(P0_range));

        for l=1:length(m_arr)
            m = m_arr(l);
            disp(m);
            
            for i=1:length(P0_range)
                P0 = P0_range(i);
                NBC=0;
                
                nbit=0; flag=0; ; 

                while nbit<NBIT

                    runlength=0;
                    if flag==0; TBIT=floor(rand+(1-P0)); else; flag=0; end

                    for k=1:2^m
                        if TBIT==1; break; end
                        TBIT=floor(rand+(1-P0)); 
                        runlength=runlength+1; 
                    end

                    if TBIT==1 & runlength>0; flag=1;  end
                    if runlength==2^m; flag=1; end
                    if runlength==0; CBLOQ='1'; TBLOQ='1'; 
                        else; CBLOQ=strcat('0',num2str(dec2bin(runlength-1,m))); TBLOQ=dec2bin(0,runlength);
                    end

                    %%%% Conteo de bits codificados
                    NBC=NBC+length(CBLOQ);
                    nbit=nbit+length(TBLOQ); 
                end

                %%%% Resultados
                Tasa_Compresion=nbit/NBC;
                Bits_P=1/Tasa_Compresion;

                % Calcular entropia basado en el tamano de la fuente
                % entropy_matrix(k, i) = calcularEntropia(m, P0);
                NC_matrix(l, i) = Bits_P;
                % zero_count(i) = length(find(TBLOQ == '0'));
                % disp(i);
            end
        end

        %% == Graficas == %%
        figure(1)
        plot(P0_range,NC_matrix(1,:),'r')
        hold on
        plot(P0_range,NC_matrix(2,:),'g')
        plot(P0_range,NC_matrix(3,:),'b')
        plot(P0_range,NC_matrix(4,:),'y')
        plot(P0_range,NC_matrix(5,:),'m')
        title('Tasa de codificación')
        xlabel('Probabilidad de ceros')
        ylabel('NC')
        legend('m=2','m=3','m=4','m=5','m=6')

        % figure(1)
        % subplot(2,1,1)
        % plot(P0_range,entropy_values,'r')
        % title('Entropia de la fuente m=' + string(m))
        % xlabel('Probabilidad de ceros')
        % ylabel('Entropia')

        % subplot(2,1,2)
        % plot(P0_range,NC_values,'g')
        % title('Tasa de codificación m=' + string(m))
        % xlabel('Probabilidad de ceros')
        % ylabel('Bits codificados por cada bit fuente')

end