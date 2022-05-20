-- alu include the reg-A and reg-c


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity ALU is
  GENERIC (OPC_length : INTEGER := 4;
            Dwidth: INTEGER := 16;
            Awidth: INTEGER := 6);
    port(	OPC:	in std_logic_vector(OPC_length-1 downto 0);
            a, b :  in std_logic_vector(Dwidth-1 downto 0);
            c : out std_logic_vector(Dwidth-1 downto 0);
            Cflag, Zflag, Nflag: out std_logic
        );
end ALU;
------------- complete the ALU Architecture code --------------
architecture arc_sys of ALU is

    SIGNAL c_buffer: std_logic_vector(Dwidth-1 DOWNTO 0);
    SIGNAL sub, carry_in: std_logic;

BEGIN

-------------- connect adderSub --------------------
sub <= '1' when OPC="0001" else '0';
carry_in <= '1' when OPC(3 downto 2) ="01" else '0';
AdderSub_pm: AdderSub
generic map (Awidth => Awidth, Dwidth => Dwidth, OPC_length=>OPC_length)
port map(
    sub => sub,
    carry_in => carry_in,
    a => a,
    b => b,
    result => c_buffer,
    carry_out => Cflag
);

Zflag <= '1' when conv_integer(c_buffer)=0 else '0';
Nflag <= '1' when c_buffer(Dwidth-1)='1' else '0';


END arc_sys;







