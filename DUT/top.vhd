LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity top is
	generic(    OPC_length: integer := 4;
				Dwidth: integer := 16;
				Awidth: integer := 6;
				dept:   integer := 64);

	port(       clk, rst, ena  : in std_logic;                                                                  -- basic control

				TBactive,RF_writeEn_from_TB, PM_writeEn_from_TB: in std_logic;                                  -- TB controls enable
				PM_dataIn_TB : in std_logic_vector(Dwidth-1 downto 0);                                          -- TB controls data
				RF_write_address_from_TB, RF_read_address_from_TB, PM_write_Addr_TB :                           -- TB controls address
						in std_logic_vector(Awidth-1 downto 0);
				done : out std_logic

	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is

signal	Cout, Cin, Ain, wrRFen, RFout, IRin, PCin, Imm_in : std_logic;                         -- control
signal	PCsel, RFaddr: std_logic_vector(1 downto 0);                                                 -- control

signal	mov, done_code, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag, done_buffer: std_logic;                 -- status
signal	OPC_buffer: std_logic_vector(OPC_length-1 downto 0);                                  			-- OPC

BEGIN

done <= done_buffer;

Control_PM: Control
generic map (Awidth => Awidth, Dwidth => Dwidth, OPC_length=>OPC_length)
port map(
	clk 		=> clk			,
	rst 		=> rst			,
	ena 		=> ena			,

	Cout		=> 	Cout		,
	Cin			=> 	Cin			,
	Ain			=> 	Ain			,
	wrRFen		=> 	wrRFen		,
	RFout		=> 	RFout		,
	IRin		=> 	IRin		,
	PCin		=> 	PCin		,
	Imm_in		=> 	Imm_in		,
	done		=> 	done_buffer	,
	PCsel		=> 	PCsel		,
	RFaddr		=> 	RFaddr		,
	OPC_in		=> 	OPC_buffer	,

	mov			=> 	mov			,
	done_code	=> 	done_code	,
	nop			=> 	nop			,
	jnc			=> 	jnc			,
	jc			=> 	jc			,
	jmp			=> 	jmp			,
	sub			=> 	sub			,
	add			=> 	add			,
	Nflag		=> 	Nflag		,
	Zflag		=> 	Zflag		,
	Cflag		=> 	Cflag		,
	OPC			=> 	open
);

DataPath_PM: DataPath
generic map (Awidth => Awidth, Dwidth => Dwidth, OPC_length=>OPC_length, dept=>dept)
port map(
	clk 		=> clk			,
	rst 		=> rst			,
	ena 		=> ena			,

	TBactive					=> TBactive						,
	RF_writeEn_from_TB			=> RF_writeEn_from_TB			,
	PM_writeEn_from_TB     		=> PM_writeEn_from_TB     		,
	PM_dataIn_TB				=> PM_dataIn_TB					,
	RF_write_address_from_TB	=> RF_write_address_from_TB		,
	RF_read_address_from_TB		=> RF_read_address_from_TB		,
	PM_write_Addr_TB			=> PM_write_Addr_TB				,


	Cout		=> 	Cout		,
	Cin			=> 	Cin			,
	Ain			=> 	Ain			,
	wrRFen		=> 	wrRFen		,
	RFout		=> 	RFout		,
	IRin		=> 	IRin		,
	PCin		=> 	PCin		,
	Imm_in		=> 	Imm_in		,
	done		=> 	done_buffer	,
	PCsel		=> 	PCsel		,
	RFaddr		=> 	RFaddr		,

	mov			=> 	mov			,
	done_code	=> 	done_code	,
	nop			=> 	nop			,
	jnc			=> 	jnc			,
	jc			=> 	jc			,
	jmp			=> 	jmp			,
	sub			=> 	sub			,
	add			=> 	add			,
	Nflag		=> 	Nflag		,
	Zflag		=> 	Zflag		,
	Cflag		=> 	Cflag		,
	OPC_out		=> 	OPC_buffer
);


END arc_sys;







