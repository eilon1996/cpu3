LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is
-----------------------------------------------------------------
	component top is
		generic (
			n : positive := 8 ;
			m : positive := 7 ;
			k : positive := 3
		); -- where k=log2(m+1)
		port(
			rst,ena,clk : in std_logic;
			x : in std_logic_vector(n-1 downto 0);
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
				carry_in : in std_logic;
				sub, carry_out : OUT std_logic);
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







end aux_package;

