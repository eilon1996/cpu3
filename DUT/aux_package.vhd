LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is
-----------------------------------------------------------------
	component top is
		GENERIC (OPC_length : INTEGER := 4;
					Dwidth : INTEGER := 16);
		port(
			rst,ena,clk : in std_logic;
			x : in std_logic_vector(Dwidth-1 downto 0);
			DetectionCode : in integer range 0 to 3;
			detector : out std_logic
		);
	end component;
-----------------------------------------------------------------
	component AdderSub is
		GENERIC (OPC_length : INTEGER := 4;
					Dwidth : INTEGER := 16);
		PORT (  a, b : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
				result : OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
				carry_in, sub : in std_logic;
				carry_out : OUT std_logic);
	end component;
-----------------------------------------------------------------
	component ALU is
		GENERIC (OPC_length : INTEGER := 4;
					Dwidth : INTEGER := 16);
		port(	OPC:	in std_logic_vector(OPC_length-1 downto 0);
				a, b : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
				c : OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
				Cflag, Zflag, Nflag: out std_logic);
	end component;

-----------------------------------------------------------------

	component PC is

	GENERIC (OPC_length : INTEGER := 4;
	Dwidth: INTEGER := 16);
	port(	clk, PCin: in std_logic;
			PCsel:	in std_logic_vector(1 downto 0);
			offset:	in std_logic_vector(4 downto 0);
			PC_value :buffer std_logic_vector(Dwidth-1 downto 0)
	);
	end component;

-----------------------------------------------------------------

	component RF is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=6);
		port(	clk,rst,WregEn: in std_logic;
				WregData:	in std_logic_vector(Dwidth-1 downto 0);
				WregAddr,RregAddr:
							in std_logic_vector(Awidth-1 downto 0);
				RregData: 	out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;


end aux_package;

