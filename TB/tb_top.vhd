library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------------
entity tb_top is
	constant n : integer := 8;
	constant m : integer := 2;
	constant k : integer := 3;
end tb_top;
--------------------------------------------------------------------

architecture rtb of tb_top is

	SIGNAL rst,ena, clk : std_logic;
	SIGNAL x : std_logic_vector(n-1 downto 0);
	SIGNAL DetectionCode : integer range 0 to 3;
	SIGNAL detector : std_logic;

begin
	L0 : top generic map (n,m,k) port map(rst,ena,clk, x, DetectionCode, detector);

	gen_clk : process
		begin
		clk <= '1';
		wait for 50 ns;
		clk <= not clk;
		wait for 50 ns;
		end process;

	gen_x : process
		begin
			x <= (others => '0');
			for i in 0 to 25 loop
				wait for 100 ns;
				x <= x+1;
			end loop;
		end process;

	gen_cond: process
		begin
			DetectionCode <= 0;
			wait;
		end process;


	gen_rst : process
		begin
			-- rst <='1','0' after 200 ns;
			rst <='0';
			wait;
		end process;

	gen_ena : process
		begin
			-- ena <='1','0' after 400 ns;
			ena <='1';
			wait;
		end process;


end architecture rtb;
