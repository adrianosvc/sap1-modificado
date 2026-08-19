/*
 * SAP-1:
 * Implementação em verilog do processador SAP-1.
 *
 * Adriano S. V. Cardoso
 * 03/2018
 * revisão: 03/2021
 */

/* 
 * Emulação da memória de RAM
 */
module ram_e(bus,address,n_oe,n_wr,clk);
inout [7:0]bus;
input [7:0]address;
input n_oe,n_wr,clk;

wire [7:0]bus;
wire [7:0]address;
wire n_oe,n_wr,clk;
wire [7:0]datain;
wire [7:0]dataout;

reg [7:0]ram[0:255];
reg [7:0]ramdata;

b3s_8_el buf_in(datain,bus,n_wr);
b3s_8_el buf_out(bus,dataout,n_oe);

assign dataout = ram[address];
always @(posedge clk)
begin
	if (~n_wr) begin
		ram[address] = datain;
	end
end

initial $readmemh("ram.hex",ram);

endmodule

/*
 * Emulação da memória ROM - programa
 * Dados a partir do arquivo (rom.hex).
 */
module rom_e(bus,address,oe);
output [11:0]bus;
input [7:0]address;
input oe;

wire [11:0]bus;
wire oe;
reg [11:0]data[0:255];

initial $readmemh("rom.hex",data);

b3s_12_el u1(bus,data[address],oe);

endmodule

/* 
 * Testbench das unidades funcionais.
 */

module tb();

reg clku, clr;
wire clk, n_clr;

assign n_clr = ~clr;

wire [7:0]W;

/* REM */
wire n_lm;		
wire [7:0]mem_a;
rem	rem1(n_lm,clk,W,mem_a);

/* RAM - dados */
wire n_ce, n_wr;
ram_e	ram1(W,mem_a,n_ce,n_wr,clk);

/* PC */
wire cp,n_lp; 		
wire [7:0]abus;
pc	pc1(cp,clk,n_clr,n_lp,W,abus);

/* ROM - programa */
wire [11:0]ibus;
rom_e	rom1(ibus,abus,1'b0);

/* RI */
wire n_li;		
wire n_ei;
wire [3:0]decod;
ri	ri1(ibus,n_li,clk,clr,n_ei,W,decod);

/* A */
wire n_la;		
wire ea;
wire [7:0]ra;
reg_a	ra1(n_la,clk,ea,W,ra);

/* B */
wire n_lb;		
wire [7:0]rb;
reg_b	rb1(n_lb,clk,W,rb);

/* ULA */
reg z;
wire [3:0]sel; 		
wire eula, C, Z;
ula_8	ula1(W,C,Z,ra,rb,sel,eula);

/* S */
wire n_ls;		
wire [7:0]rs;
reg_s	r1(n_ls,clk,W,rs);

/* Máquina de estados da unidade de controle */
wire t1,t2,t3,t4;
sm	sm1(clr,clk,t1,t2,t3,t4);

/* 
 * Unidade de controle.
 */
control	ctrl1(clr,clku,t1,t2,t3,t4,decod,Z,
       n_lm,n_wr,n_ce,cp,n_li,n_ei,n_la,ea,sel,eula,n_lb,n_ls,n_lp,clk);

initial begin
	$dumpfile("sap-1D_run.vcd"); /* included for GTKWave file generation */
	$dumpvars(0,tb);           /* included for GTKWave file generation */
	
	/* Initial values */
	clku = 0;
	clr = 0;
	#1
	clr = 1;
	#1
	clr = 0;
	#3400

	$finish;
end

always begin
	#5 clku = ~clku;	
end

endmodule

