library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tb_control is

			constant    numOfStatus: integer := 2;
            constant    numOfStates: integer := 2;
            constant    numOfControlsBits : integer := 4;
  end tb_control;

architecture xxxx of tb_control is

	SIGNAL clk: std_logic;    --from tb
	SIGNAL status_vector: std_logic_vector(numOfStatus-1 downto 0);
	SIGNAL control_vector: std_logic_vector(numOfControlsBits-1 downto 0);

begin


	control_PM: control
    generic map (numOfStatus => numOfStatus, numOfStates => numOfStates, numOfControlsBits => numOfControlsBits)
    port map(
                 clk                         => clk          ,
                 status_vector       => open			,
                 control_vector       => control_vector
     );

	 status_vector <= (others => '0');

	 gen_clk : process
	 begin

		clk <='0','1' after 20ns,'0' after 20ns,'1' after 20ns;
		wait;
	 end process;

end architecture xxxx;




