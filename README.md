# SAP-1 Modificado

Arquitetura SAP-1 modificada para adição de funcionalidades, utilizadas na disciplina "Microprocessadores" dos cursos de Engenharia Mecatrônica e Engenharia de Telecomunicações da UFSJ.

## Modificações

1) Separação da memória de dados e memória de código - arquitetura Harvard;
2) Registro de endereço de memória de dados (REM) com 8 bits, possibilitando 256 linha de memória;
3) Registro de instrução de 12 bits, possibilitando 8 bits de endereço e 4 de opcode;
4) Substituição da unidade aritmética por uma Unidade Lógica e Aritmética de 8 bits;
5) Adição de 11 novas instruções  - ver "apresentacao.pdf". 

### Requisitos

Icarus verilog:
https://steveicarus.github.io/iverilog/

GTKWave:
https://gtkwave.sourceforge.net/

### Utilização 

1) Para compilar - terminal de comandos:

$ iverilog basicos.v ula-8.v sap-1d.v tb_sap-1d.v -o sap-1

2) Para executar a simulação:

$ vvp sap-1

3) Para visualizar os resultados usando o GTKWave:

$ gtkwave sap-1D_run.vcd


## Referência

Arquitetura SAP-1: 
Albert P. Malvino, Microcomputadores e Microprocessadores, 1985.
