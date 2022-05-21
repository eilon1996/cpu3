LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is
-----------------------------------------------------------------
	component AdderSub is
		GENERIC (Dwidth : INTEGER := 16);
		PORT (  a, b : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
				result : OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
				carry_in, sub : in std_logic;
				carry_out : OUT std_logic);
	end component;
-----------------------------------------------------------------
	component ALU is
		GENERIC (OPC_length : INTEGER := 4;
					Awidth : INTEGER := 6;
					Dwidth : INTEGER := 16);
		port(	OPC:	in std_logic_vector(OPC_length-1 downto 0);
				a, b : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
				c : OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
				Cflag, Zflag, Nflag: out std_logic);
	end component;

-----------------------------------------------------------------
	component ProgMem is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=6;
				 dept:   integer:=64);
		port(	clk,PM_writeEn: in std_logic;											-- clk, wren
				PM_dataIn:	in std_logic_vector(Dwidth-1 downto 0); 					-- datain
				PM_writeAddr, PM_readAddr:	in std_logic_vector(Awidth-1 downto 0); 	-- writeAddr, readAddr
				PM_readData: 	out std_logic_vector(Dwidth-1 downto 0) 				-- dataOut
			);
	end component;

-----------------------------------------------------------------
	component PC is

	GENERIC (OPC_length : INTEGER := 4;
				Awidth : INTEGER := 6;
				Dwidth : INTEGER := 16);
	port(	clk, PCin: in std_logic;
			PCsel:	in std_logic_vector(1 downto 0);
			offset:	in std_logic_vector(4 downto 0);
			PC_out :out std_logic_vector(Awidth-1 downto 0)
	);
	end component;

-----------------------------------------------------------------

	component RF is
		GENERIC (	Awidth : INTEGER := 4;
					Dwidth : INTEGER := 16);
		port(	clk,rst,RF_writeEn: in std_logic;
				RF_write_data:	in std_logic_vector(Dwidth-1 downto 0);
				RF_write_address,RF_read_address:
								in std_logic_vector(Awidth-1 downto 0);
				RF_read_data: 	out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;


-----------------------------------------------------------------

	component Control is
		GENERIC (OPC_length : INTEGER := 4;
					Awidth : INTEGER := 6;
					Dwidth : INTEGER := 16);
		port(
			rst, ena, clk: in std_logic;    --from tb
			done: out std_logic;            --to tb
			mov, done_code, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag : in std_logic;  	--status
			Cout, Cin, Ain, RF_writeEn_control, RFout, IRin, PCin, Imm_in : out std_logic;    				--control
			PCsel, RFaddr: out std_logic_vector(1 downto 0);                                    --control
			OPC_in: in std_logic_vector(OPC_length-1 downto 0);                                 --control
			OPC: out std_logic_vector(OPC_length-1 downto 0)                                    --control
		);
		end component;

-----------------------------------------------------------------

	component DataPath is
		generic(    OPC_length: integer := 4;
					Dwidth: integer := 16;
					Awidth: integer := 6;
					regAddrWidth: integer := 4;
					dept:   integer := 64);

		port(       clk, rst, ena  : in std_logic;                                                                  -- basic control
					Cout, Cin, Ain, RF_writeEn_control, RFout, IRin, PCin, Imm_in, done : in std_logic;                         -- control
					PCsel, RFaddr: in std_logic_vector(1 downto 0);                                                 -- control

					TBactive,RF_writeEn_from_TB, PM_writeEn_from_TB: in std_logic;                                  -- TB controls enable
					PM_dataIn_TB : in std_logic_vector(Dwidth-1 downto 0);                              -- TB controls data
					PM_write_Addr_TB :  in std_logic_vector(Awidth-1 downto 0);                                     -- TB controls address PM
					RF_write_address_from_TB, RF_read_address_from_TB : in std_logic_vector(regAddrWidth-1 downto 0); -- TB controls address RF


					mov, done_code, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag: out std_logic;                 -- status
					OPC_out: out std_logic_vector(OPC_length-1 downto 0)                                  			-- OPC
		);
		end component;

-----------------------------------------------------------------
	component top is
		generic(    OPC_length: integer := 4;
					Dwidth: integer := 16;
					Awidth: integer := 6;
					regAddrWidth: integer := 4;
					dept:   integer := 64);

		port(       clk, rst, ena  : in std_logic;                                                                  -- basic control

					TBactive,RF_writeEn_from_TB, PM_writeEn_from_TB: in std_logic;                                  -- TB controls enable
					PM_dataIn_TB : in std_logic_vector(Dwidth-1 downto 0);                                     -- TB controls data
					RF_write_address_from_TB, RF_read_address_from_TB : in std_logic_vector(regAddrWidth-1 downto 0);
					PM_write_Addr_TB : in std_logic_vector(Awidth-1 downto 0);
					done : out std_logic

		);
	end component;
end aux_package;

