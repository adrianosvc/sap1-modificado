/*
 * SAP-1d:
 * Implementação em verilog do processador SAP-1 modificado (SAP-1D).
 * Consiste da adição das instruções de desvio ao SAP-1C: 
 * jp  -> desvio incondicional;
 * jpz -> desvio condicional ao bit Z da ULA.
 *
 *
 * Adriano S. V. Cardoso
 * 08/2021
 */

/****************************************************************************** 
 * Componentes do SAP-1D.
 *****************************************************************************/

/* 
 * PC
 */ 
module pc(cp,clk,n_clr,n_lp,w,abus);
input cp; 		/* habilita contador */
input clk;		/* clock */
input n_clr;		/* clear */
input n_lp;            /* habilita escrita no registro */
input [7:0]w;           /* bus */
output [7:0]abus;  	/* endereço: conectado à memória de programa */

wire cp, n_clk, n_clr, n_lp;
wire [7:0]w;
reg [7:0]abus;

always @(posedge clk)
begin
	if (cp) begin
		abus = abus + 1;
	end
	if (~n_lp) begin
		abus <= w;
	end
end

always @(*)
	if (~n_clr) begin
		abus = 0;
	end

endmodule

/*
 * REM
 */
module rem(n_lm,clk,bus,out);
input n_lm;		/* habilita entrada de dados */
input clk;		/* clock */
inout [7:0]bus;		/* entrada de dados: barramento W */
output [7:0]out;	/* endereço da RAM */

wire n_lm, clk;
wire [7:0]bus;
wire [7:0]out;
reg [7:0]a;

always @(posedge clk)
	if (~n_lm) begin
		a <= bus;
	end

assign out = a;

endmodule

/* 
 * RI
 */ 
module ri(mp,n_li,clk,clr,n_ei,bus,decod);
input [11:0]mp;		/* memória de programa */
input n_li; 		/* habilita entrada de dados */
input clk;		/* clock */
input clr;		/* clear */
input n_ei;		/* habilita saída para o barramento W */
inout [7:0]bus;		/* barramento W */
output [3:0]decod;  	/* saída para o decodificador */

wire [11:0]mp;
wire n_li, clk, clr, n_ei;
wire [7:0]bus;
wire [3:0]decod;
reg [11:0]r;
wire [7:0]rr;

always @(posedge clk)
	if (~n_li) begin
		r <= mp;
	end

always @(*)
	if (clr) begin
		r = 12'hD00;
	end

assign decod = r[11:8];
assign rr = r[7:0];
b3s_8_el u1(bus,rr,n_ei);

endmodule

/*
 * A
 */
module reg_a(n_la,clk,ea,bus,out);
input n_la;		/* habilita entrada de dados */
input clk;		/* clock */
input ea;		/* habilita saída */
inout [7:0]bus;		/* barramento W */
output [7:0]out;	/* saída para a UA */

wire n_la;
wire clk;
wire ea;
wire [7:0]bus;
wire [7:0]out;
reg [7:0]a;

always @(posedge clk)
	if (~n_la) begin
		a <= bus;
	end

assign out = a;
b3s_8_eh u1(bus,out,ea);

endmodule

/*
 * B
 */
module reg_b(n_lb,clk,bus,out);
input n_lb;		/* habilita entrada de dados */
input clk;		/* clock */
inout [7:0]bus;		/* barramento W */
output [7:0]out;	/* saída para a UA */

wire n_lb;		
wire clk;
wire [7:0]bus;
wire [7:0]out;
reg [7:0]b;

always @(posedge clk)
	if (~n_lb) begin
		b <= bus;
	end

assign out = b;

endmodule

/*
 * S
 */
module reg_s(n_ls,clk,bus,out);
input n_ls;		/* habilita entrada de dados */
input clk;		/* clock */
inout [7:0]bus;		/* barramento W */
output [7:0]out;	/* saída para o mostrador */

wire n_ls;
wire clk;
wire [7:0]bus;
wire [7:0]out;
reg [7:0]s;

always @(posedge clk)
	if (~n_ls) begin
		s <= bus;
	end

assign out = s;

endmodule

/****************************************************************************** 
 * Unidade de controle do SAP-1.
 *****************************************************************************/

/*
 * Máquina de estados - contador em anel.
 */
module sm(clr,clk,t1,t2,t3,t4);
input clr;
input clk;
output t1;
output t2;
output t3;
output t4;

wire clr;
wire clk;
wire t1;
wire t2;
wire t3;
wire t4;

reg [4:0]r;

always @(negedge clk)
	begin
		r = r << 1;
		r[0] = r[4];
	end

always @(*)
	if (clr) begin
		r = 5'b00001;
	end

assign t1 = r[0];
assign t2 = r[1];
assign t3 = r[2];
assign t4 = r[3];

endmodule

/*
 * Decodificador de instruções
 */
module dec_inst(inst,dec);
input [3:0]inst;
output [15:0]dec;

wire [3:0]inst;
wire [15:0]dec;

assign dec = (inst==4'b0000) ? 16'b1000000000000000 :	// LDA x - 0xx
	     (inst==4'b0001) ? 16'b0100000000000000 :	// ADD x - 1xx
	     (inst==4'b0010) ? 16'b0010000000000000 :	// SUB x - 2xx
	     (inst==4'b0011) ? 16'b0001000000000000 :	// AND x - 3xx
	     (inst==4'b0100) ? 16'b0000100000000000 :	// OR x  - 4xx
	     (inst==4'b0101) ? 16'b0000010000000000 :	// XOR x - 5xx
	     (inst==4'b0110) ? 16'b0000001000000000 :	// INC   - 6--
	     (inst==4'b0111) ? 16'b0000000100000000 :	// DEC   - 7--
	     (inst==4'b1000) ? 16'b0000000010000000 :	// SL    - 8--
	     (inst==4'b1001) ? 16'b0000000001000000 :	// SR    - 9--
	     (inst==4'b1010) ? 16'b0000000000100000 :	// CMP   - A--
	     (inst==4'b1011) ? 16'b0000000000010000 :	// jp    - Byy
	     (inst==4'b1100) ? 16'b0000000000001000 :	// jz    - Cyy
	     (inst==4'b1101) ? 16'b0000000000000100 :	// ST x  - Dxx 
	     (inst==4'b1110) ? 16'b0000000000000010 :	// OUT   - E--
	     (inst==4'b1111) ? 16'b0000000000000001 :   // HALT  - F--
	     		       16'b0000000000000000;

endmodule

/* REGISTRADOR DE 1-BIT (Z) */
module reg_z(zout,zin,en,clk);
output zout;
input zin,en,clk;

wire zin,en,clk;
reg zout;

always @(posedge clk)
begin
	if (en) zout <= zin;
end

endmodule

/* 
 * Unidade de controle.
 */
module control(clr,clku,t1,t2,t3,t4,ri,Z,
       n_lm,n_wr,n_ce,cp,n_li,n_ei,n_la,ea,sel,eula,n_lb,n_ls,n_lp,clk);

input clr,clku,t1,t2,t3,t4,Z;
input [3:0]ri;
output n_lm,n_wr,n_ce,cp,n_li,n_ei,n_la,ea,eula,n_lb,n_ls,n_lp,clk;
output [3:0]sel;

wire clr,clku,t1,t2,t3,t4,Z;
wire [3:0]ri;
wire n_lm,n_wr,n_ce,cp,n_li,n_ei,n_la,ea,eula,n_lb,n_ls,clk;
wire [3:0]sel;
reg hlt;

wire [15:0]decd;
wire lda,sto,sum,sub,inc,dec,sra,sla,ann,orr,xoo,noo,out,halt;
dec_inst 	di(ri,decd);

assign lda = decd[15];
assign add = decd[14];
assign sub = decd[13];
assign _and_ = decd[12];
assign _or_ = decd[11];
assign _xor_ = decd[10];
assign inc = decd[9];
assign dec = decd[8];
assign sl = decd[7];
assign sr = decd[6];
assign cmp = decd[5];
assign jp = decd[4];
assign jz = decd[3];
assign st = decd[2];
assign out = decd[1];
assign halt = decd[0];

assign n_li = ~t1;
assign cp = t2;

assign n_ei = ~(t2&lda) & ~(t2&add) & ~(t2&sub) & ~(t2&_and_) & ~(t2&_or_) &
              ~(t2&_xor_) & ~(t2&st) & ~(t3&jp) & ~(t3&jz);
assign n_lm = n_ei;

assign n_ce = ~(t3&lda) & ~(t3&add) & ~(t3&sub) & ~(t3&_and_) & ~(t3&_or_) &
       	      ~(t3&_xor_);

assign n_la = ~(t3&lda) & ~(t4&add) & ~(t4&sub) & ~(t4&_and_) & ~(t4&_or_) &
              ~(t4&_xor_) & ~(t3&inc) & ~(t3&dec) & ~(t3&sl) & ~(t3&sr) &
	      ~(t3&cmp);

assign ea = (t2&inc) | (t2&dec) | (t2&sl) | (t2&sr) | (t2&cmp) |
            (t3&st)  | (t2&out);

assign n_wr = ~(t3&st);

assign n_lb = ~(t3&add) & ~(t3&sub) & ~(t3&_and_) & ~(t3&_or_) & ~(t3&_xor_) & 
              ~(t2&inc) & ~(t2&dec) & ~(t2&sl) & ~(t2&sr) & ~(t2&cmp);

assign eula = (t4&add) | (t4&sub) | (t4&_and_) | (t4&_or_) | (t4&_xor_) | 
	      (t3&inc) | (t3&dec) | (t3&sl) | (t3&sr) | (t3&cmp);

assign n_ls = ~(t2&out);

assign n_lp = ~(t3&jp) & ~(t3&jz&z);

assign sel[0] = (t4&(sub|_or_)) | (t3&(dec|sl|cmp));
assign sel[1] = (t4&(_xor_)) | (t3&(inc|dec|sr|cmp)); 
assign sel[2] = t3&(sl|sr);
assign sel[3] = (t4&(_and_|_or_|_xor_)) | (t3&cmp);

assign z_en = (t4&add) | (t4&sub) | (t4&_and_) | (t4&_or_) | (t4&_xor_) |
              (t3&inc) | (t3&dec) | (t3&sl) | (t3&sr) | (t3&cmp);	

assign clk = clku & hlt;

always @(*)
if (clr) begin
	hlt = 1;
end

always @(negedge t3)
if (halt) begin
	hlt = 0;
end

reg_z rz1(z,Z,z_en,clk);

endmodule

