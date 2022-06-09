LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is
	component control is
		generic(    numOfStatus: integer := 2;
			numOfStates: integer := 2;
			numOfControlsBits : integer := 4);

		port(
			clk: in std_logic;    --from tb
			status_vector: out std_logic_vector(numOfStatus-1 downto 0);
			control_vector: out std_logic_vector(numOfControlsBits-1 downto 0)
		);
	end component;
end aux_package;

