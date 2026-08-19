/*
 * SAP-1:
 * Implementação em verilog do processador SAP-1.
 *
 * Adriano S. V. Cardoso
 * 03/2018
 * revisão: 03/2021
 */

/****************************************************************************** 
 * Componentes elementares.
 *****************************************************************************/

/* 
 * Buffer 3-state 4 bits.
 * Habilitação em 1; 
 */
module b3s_4_eh(out,in,en);
input [3:0]in;
output [3:0]out;
input en;

wire [3:0]in;
wire [3:0]out;
wire en;

bufif1 u3(out[3],in[3],en);
bufif1 u2(out[2],in[2],en);
bufif1 u1(out[1],in[1],en);
bufif1 u0(out[0],in[0],en);

endmodule

/* 
 * Buffer 3-state 4 bits.
 * Habilitação em 0; 
 */
module b3s_4_el(out,in,en);
input [3:0]in;
output [3:0]out;
input en;

wire [3:0]in;
wire [3:0]out;
wire en;

bufif0 u3(out[3],in[3],en);
bufif0 u2(out[2],in[2],en);
bufif0 u1(out[1],in[1],en);
bufif0 u0(out[0],in[0],en);

endmodule

/* 
 * Buffer 3-state 8 bits.
 * Habilitação em 0; 
 */
module b3s_8_el(out,in,en);
input [7:0]in;
output [7:0]out;
input en;

wire [7:0]in;
wire [7:0]out;
wire en;

bufif0 u7(out[7],in[7],en);
bufif0 u6(out[6],in[6],en);
bufif0 u5(out[5],in[5],en);
bufif0 u4(out[4],in[4],en);
bufif0 u3(out[3],in[3],en);
bufif0 u2(out[2],in[2],en);
bufif0 u1(out[1],in[1],en);
bufif0 u0(out[0],in[0],en);

endmodule

/* 
 * Buffer 3-state 12 bits.
 * Habilitação em 0; 
 */
module b3s_12_el(out,in,en);
input [11:0]in;
output [11:0]out;
input en;

wire [11:0]in;
wire [11:0]out;
wire en;

bufif0 u11(out[11],in[11],en);
bufif0 u10(out[10],in[10],en);
bufif0 u9(out[9],in[9],en);
bufif0 u8(out[8],in[8],en);
bufif0 u7(out[7],in[7],en);
bufif0 u6(out[6],in[6],en);
bufif0 u5(out[5],in[5],en);
bufif0 u4(out[4],in[4],en);
bufif0 u3(out[3],in[3],en);
bufif0 u2(out[2],in[2],en);
bufif0 u1(out[1],in[1],en);
bufif0 u0(out[0],in[0],en);

endmodule

/* 
 * Buffer 3-state 8 bits.
 * Habilitação em 1; 
 */
module b3s_8_eh(out,in,en);
input [7:0]in;
output [7:0]out;
input en;

wire [7:0]in;
wire [7:0]out;
wire en;

bufif1 u7(out[7],in[7],en);
bufif1 u6(out[6],in[6],en);
bufif1 u5(out[5],in[5],en);
bufif1 u4(out[4],in[4],en);
bufif1 u3(out[3],in[3],en);
bufif1 u2(out[2],in[2],en);
bufif1 u1(out[1],in[1],en);
bufif1 u0(out[0],in[0],en);

endmodule

/*
 * MUX 2 entradas
 */ 
module mux(in0,in1,sel,out);
input in0;
input in1;
input sel;
output out;

wire in0;
wire in1;
wire sel;
wire out;

assign out = sel ? in1 : in0;

endmodule

/*
 * MUX-8 2 entradas
 */ 
module mux8(in0,in1,sel,out);
input [7:0]in0;
input [7:0]in1;
input sel;
output [7:0]out;

wire [7:0]in0;
wire [7:0]in1;
wire sel;
wire [7:0]out;

mux	mux_0(in0[0],in1[0],sel,out[0]);
mux	mux_1(in0[1],in1[1],sel,out[1]);
mux	mux_2(in0[2],in1[2],sel,out[2]);
mux	mux_3(in0[3],in1[3],sel,out[3]);
mux	mux_4(in0[4],in1[4],sel,out[4]);
mux	mux_5(in0[5],in1[5],sel,out[5]);
mux	mux_6(in0[6],in1[6],sel,out[6]);
mux	mux_7(in0[7],in1[7],sel,out[7]);

endmodule

/*
 * Somador de 8 bits.
 */ 
module adder_8(ina,inb,out);
input [7:0]ina;
input [7:0]inb;
output [7:0]out;

wire [7:0]ina;
wire [7:0]inb;
wire [7:0]out;

assign out = ina+inb;

endmodule

/*
 * Complemento de 2 com seleção.
 */ 
module c2_8(in,out,c2);
input [7:0]in;
output [7:0]out;
input c2;

wire [7:0]in;
wire [7:0]out;
wire c2;

assign out = c2 ? (~in + 1) : in;

endmodule

