/* 
 * Unidade lógica e aritmética de 8-bits.
 *
 * Adriano S. V. Cardoso 
 * revisão: 06/2021
 */

/* Somador completo de 1-bit */
module somador_1_bit(y,co,a,b,ci);
output y,co;
input a,b,ci;
wire y,co,a,b,ci;

assign y = (a^b)^ci;
assign co = (a&b)|(a&ci)|(b&ci);
endmodule

/* Complemento de 2 1-bit */
module comp_2(y,sco,a,sub,sci);
output y,sco;
input a,sub,sci;
wire y,sco,a,sub,sci,x;

assign x = a^sub;
assign y = x^sci;
assign sco = x&sci;

endmodule

/*
 **********************************
 * Somador e subtrator de 16-bits *
 * sub = 0: soma                  *
 * sub = 1: subtração             *
 **********************************
 */
module somador_subtrator_8_bits(y,c,a,b,sub);
output [7:0]y;
output c;
input [7:0]a;
input [7:0]b;
input sub;

wire [7:0]y;
wire c;
wire [7:0]a;
wire [7:0]b;
wire sub;


wire [7:0]sc;
wire [7:0]yc;

comp_2 cp2_01(yc[0],sc[0],a[0],sub,sub);
comp_2 cp2_02(yc[1],sc[1],a[1],sub,sc[0]);
comp_2 cp2_03(yc[2],sc[2],a[2],sub,sc[1]);
comp_2 cp2_04(yc[3],sc[3],a[3],sub,sc[2]);
comp_2 cp2_05(yc[4],sc[4],a[4],sub,sc[3]);
comp_2 cp2_06(yc[5],sc[5],a[5],sub,sc[4]);
comp_2 cp2_07(yc[6],sc[6],a[6],sub,sc[5]);
comp_2 cp2_08(yc[7],sc[7],a[7],sub,sc[6]);

wire [7:0]cc;

somador_1_bit s01(y[0],cc[0],yc[0],b[0],1'b0);
somador_1_bit s02(y[1],cc[1],yc[1],b[1],cc[0]);
somador_1_bit s03(y[2],cc[2],yc[2],b[2],cc[1]);
somador_1_bit s04(y[3],cc[3],yc[3],b[3],cc[2]);
somador_1_bit s05(y[4],cc[4],yc[4],b[4],cc[3]);
somador_1_bit s06(y[5],cc[5],yc[5],b[5],cc[4]);
somador_1_bit s07(y[6],cc[6],yc[6],b[6],cc[5]);
somador_1_bit s08(y[7],cc[7],yc[7],b[7],cc[6]);

assign c = cc[7];

endmodule


/* MUX de 4 entradas 1-bit */
module mux_4_1bit(out,in0,in1,in2,in3,sel);
output out;
input in0,in1,in2,in3;
input [1:0]sel;

wire out;
wire in0,in1,in2,in3;
wire [1:0]sel;

assign out = (sel == 2'b00) ? in0 :
             (sel == 2'b01) ? in1 :
             (sel == 2'b10) ? in2 :
             (sel == 2'b11) ? in3 : 0;
endmodule

/*
 *************************************
 * Deslocador binário de 16-bits     *
 * sel = 00: sem deslocamento        *
 * sel = 01: deslocamento a esquerda *
 * sel = 10: deslocamento a direita  *
 *************************************
 */
module shifter_8(y,x,sel);
output [7:0]y;
input [7:0]x;
input [1:0]sel;

wire [7:0]y;
wire [7:0]x;
wire [1:0]sel;

mux_4_1bit m01(y[0],x[0],1'b0,x[1],1'b1,sel);
mux_4_1bit m02(y[1],x[1],x[0],x[2],1'b0,sel);
mux_4_1bit m03(y[2],x[2],x[1],x[3],1'b0,sel);
mux_4_1bit m04(y[3],x[3],x[2],x[4],1'b0,sel);
mux_4_1bit m05(y[4],x[4],x[3],x[5],1'b0,sel);
mux_4_1bit m06(y[5],x[5],x[4],x[6],1'b0,sel);
mux_4_1bit m07(y[6],x[6],x[5],x[7],1'b0,sel);
mux_4_1bit m08(y[7],x[7],x[6],1'b0,1'b1,sel);

endmodule

/* MUX de 2 entradas 8-bit */
module mux_2_8bit(out,in0,in1,sel);
output [7:0]out;
input [7:0]in0,in1;
input sel;

wire [7:0]out;
wire [7:0]in0,in1;
wire sel;

assign out = sel ? in1 : in0;

endmodule

/* MUX de 4 entradas 16-bit */
module mux_4_8bit(out,in0,in1,in2,in3,sel);
output [7:0]out;
input [7:0]in0,in1,in2,in3;
input [1:0]sel;

wire [7:0]out;
wire [7:0]in0,in1,in2,in3;
wire [1:0]sel;

assign out = (sel == 2'b00) ? in0 :
             (sel == 2'b01) ? in1 :
             (sel == 2'b10) ? in2 :
             (sel == 2'b11) ? in3 : 0;
endmodule

/*
 *************************************
 * Unidade lógica                    *
 * sel = 00: and                     *
 * sel = 01: or                      *
 * sel = 10: xor                     *
 * sel = 11: not B                   *
 *************************************
 */
module logica_8(y,a,b,sel);
output [7:0]y;
input [7:0]a,b;
input [1:0]sel;

wire [7:0]y;
wire [7:0]a,b;
wire [1:0]sel;

wire [7:0]y1,y2,y3,y4;
assign y1 = a & b;
assign y2 = a | b;
assign y3 = a ^ b;
assign y4 = ~b;

mux_4_8bit m1(y,y1,y2,y3,y4,sel);
endmodule

/*
 *************************************
 * Unidade lógica e aritmética       *
 * sel[3:2] = 00: aritmética         *
 *   sel[1:0] = 00: soma	     *
 *   sel[1:0] = 01: subtração	     *	
 *   sel[1:0] = 10: incremento	     *
 *   sel[1:0] = 11: decremento	     *	
 *                                   *
 * sel[3:2] = 01: deslocamento de b  *
 *   sel[1:0] = 00: sem deslocamento *
 *   sel[1:0] = 01: a esquerda	     *	
 *   sel[1:0] = 10: a direita	     *	
 *   sel[1:0] = 11: constante 0x8001 *	
 *                                   *
 * sel[3:2] = 10: logica             *
 *   sel[1:0] = 00: and              *
 *   sel[1:0] = 01: or               *	
 *   sel[1:0] = 10: xor              *	
 *   sel[1:0] = 11: not b            *
 *                                   *
 * sel[3:2] = 11: constantes         *
 *   *sel[1:0] = 00: 0x0000           *
 *   *sel[1:0] = 01: 0x0001           *	
 *   *sel[1:0] = 10: 0x00FF           *	
 *   *sel[1:0] = 11: 0xFF00           *
 *                                   *	
 *                                   *
 *************************************
 */
module ula_8(y,C,Z,a,b,sel,oe);
output [7:0]y;
output C,Z;
input [7:0]a,b;
input [3:0]sel;
input oe;

wire [7:0]y;
wire C,Z;
wire [7:0]a,b,as;
wire [3:0]sel;
wire oe;

wire [7:0]ys;
mux_2_8bit	m0(as,a,8'h01,sel[1]);
somador_subtrator_8_bits s1(ys,C,as,b,sel[0]);

wire [7:0]yl;
logica_8 l1(yl,a,b,sel[1:0]);

wire [7:0]yh;
shifter_8 h1(yh,b,sel[1:0]);

wire [7:0]yy;
wire [7:0]yo;
mux_4_8bit m2(yy,8'h00,8'h01,8'h0f,8'hf0,sel[1:0]);
mux_4_8bit m1(yo,ys,yh,yl,yy,sel[3:2]);

assign Z = (yo == 8'h00) ? 1 : 0;
assign y = (oe) ? yo : 8'bzzzzzzzz;

endmodule


/* REGISTRADOR DE 8-BIT */
module reg_8(out,in,en,clk);
output [7:0]out;
input [7:0]in;
input en,clk,oe,clr;

wire [7:0]out;
wire [7:0]in;
wire en,clk,oe,clr;
reg [7:0]outi;

always @(posedge clk)
begin
	if (en) outi <= in;
end

assign out = outi;

endmodule


