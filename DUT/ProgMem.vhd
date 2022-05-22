library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity ProgMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk,PM_writeEn: in std_logic;																				-- clk, wren
		PM_dataIn:	in std_logic_vector(Dwidth-1 downto 0); 									-- datain
		PM_writeAddr, PM_readAddr:	in std_logic_vector(Awidth-1 downto 0); 	-- writeAddr, readAddr
		PM_readData: 	out std_logic_vector(Dwidth-1 downto 0) 								-- dataOut
);
end ProgMem;
--------------------------------------------------------------
architecture behav of ProgMem is

type RAM is array (0 to dept-1) of
	std_logic_vector(Dwidth-1 downto 0);
signal sysRAM: RAM;

begin
  process(clk)
  begin
	if (clk'event and clk='1') then
	    if (PM_writeEn='1') then
		    -- index is type of integer so we need to use
				-- buildin function conv_integer in order to change the type
		    -- from std_logic_vector to integer
			sysRAM(conv_integer(PM_writeAddr)) <= PM_dataIn;
	    end if;
	end if;
  end process;

  PM_readData <= sysRAM(conv_integer(PM_readAddr));

	end behav;

