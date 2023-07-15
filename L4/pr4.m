% EC1482 Laboratorio de Comunicaciones Digitales
% Versi�n 2003
% Simulaciones Computarizadas - PRACTICA 8
% Autor: Prof. Renny E. Badra, Ph.D.

clear;

%%%% Personalizaci�n de la simulacion
C1=10315; % n�mero de carnet del integrante 1 (cinco digitos)
C2=10526; % n�mero de carnet del integrante 2 (cinco d�gitos)

%%%% Par�metros B�sicos e Inicializacion de Variables
rand('state',C1); randn('state',C2); % inicializacion de los generadores seudoaleatorios
P0=0.75; %Probabilidad de cero de la fuente
NBIT=5000; %n�mero de bits a simular (entero)
m=2; %longitud del bloque (run_length)
SECF='Secuencia Fuente: ';
SECC='Secuencia Codigo: ';
NBC=0;

%%%% Seleccion del C�digo de Canal
tipo_codigo=input('Codigo a simular? A=Huffman B=run_length ','s');


switch tipo_codigo


%%%%%%%%%% Codigo Huffman

case {'a','A'}

% fuente={'000' '001' '010' '011' '100' '101' '110' '111'};	%contiene 2^LH strings con todas las palabras binarias de LH bits 
% codigo={'0' '100' '101' '110' '11100' '11101' '11110' '11111'}; %mapeo del Codigo Huffman
fuente={'0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111',...
        '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111'};	    % contiene 2^LH strings con todas las palabras binarias de LH bits
codigo={'00', '100', '101', '110', '111', '01000', '01001', '01010',...
         '01011', '01100', '01101', '011101', '011110', '011111', '011000', '011001'};
LH=length(char(fuente(1))); %longitud de la palabra binaria fuente (Huffman)

NBLOQ=ceil(NBIT/LH); % numero de bloques a simular

%%%% Lazo central empieza aqu�
for nbloq=1:NBLOQ

%%%% Generaci�n del caudal de bits
TBIT=floor(rand+(1-P0)); TBLOQ=num2str(TBIT);
for k=2:LH; TBIT=floor(rand+(1-P0)); TBLOQ=strcat(TBLOQ,num2str(TBIT)); end

%%%% Codificador Huffman
indice=strmatch(TBLOQ,fuente);
CBLOQ=codigo(indice);

%%%% Conteo de bits codificados
NBC=NBC+length(char(CBLOQ));

%%%% Guardar secuencias
if NBIT<32
SECF=strcat(SECF,TBLOQ);
SECC=strcat(SECC,CBLOQ);
end

end

%%%% Resultados
Tasa_Compresion=NBLOQ*LH/NBC
Bits_P=1/Tasa_Compresion;
NC=strcat(num2str(Bits_P),' bits codificados por cada bit fuente (NC)'); disp(NC);
if NBIT<32; disp(SECF); disp(SECC); end





%%%%%%%%%% Codigo Run_Length

case {'b','B'}

nbit=0; flag=0; ; 

while nbit<NBIT

%%%% Codificador Run_Length

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

%%%% Guardar secuencias
if NBIT<32 
SECF=strcat(SECF,TBLOQ); 
SECC=strcat(SECC,CBLOQ);
end

nbit=nbit+length(TBLOQ); 
end

%%%% Resultados
Tasa_Compresion=nbit/NBC
Bits_P=1/Tasa_Compresion;
NC=strcat(num2str(Bits_P),' bits codificados por cada bit fuente (NC)'); disp(NC);
if NBIT<32;  disp(SECF); disp(SECC); end

end
