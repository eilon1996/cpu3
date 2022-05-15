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
		GENERIC (length : INTEGER := 16);
        PORT (  a, b : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
                result : OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
                carry_in : in std_logic;
                sub, carry_out : OUT std_logic);
    end component;
-----------------------------------------------------------------
	component ProgMem is
		generic( Dwidth: integer := 16;
		 		 Awidth: integer := 6;
				 dept:   integer := 64);
		port(   clk: in std_logic;	
				 memDataIn:	in std_logic_vector(m-1 downto 0);
				 rfDataIn : in std_logic_vector(n-1 downto 0);
				 rfDataOut: out std_logic_vector(n-1 downto 0)
		 );	 
	end component;






  
  
  
  
end aux_package;

