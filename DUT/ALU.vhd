-- alu include the reg-A and reg-c


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity ALU is
  GENERIC (OPC_length : INTEGER := 4;
            Dwidth: INTEGER := 16);
    port(	clk, rst, Ain, Cin, Cout: in std_logic;
            OPC:	in std_logic_vector(OPC_length-1 downto 0);
            data_bus :buffer std_logic_vector(Dwidth-1 downto 0);
            Cflag, Zflag, Nflag: buffer std_logic;
        );
end ALU;
------------- complete the ALU Architecture code --------------
architecture arc_sys of ALU is

    component AdderSub is
        PORT (  a, b : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
                result : OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
                carry_in : in std_logic;
                sub, carry_out : OUT std_logic);
    end component;

    SIGNAL a, b, c, c_reg : std_logic_vector(n-1 DOWNTO 0);
    SIGNAL sub, carry_in: std_logic;

    alias OPC_type : std_logic_vector(1 downto 0) is OPC(3 downto 2);
    alias R_type   : std_logic_vector(1 downto 0) is "00";
    alias J_type   : std_logic_vector(1 downto 0) is "01";
    alias I_type   : std_logic_vector(1 downto 0) is "10";


BEGIN


-------------- monitor a value --------------------
PROCESS (data_bus, Ain, clk)
    BEGIN
        IF (rising_edge(clk)) THEN	-- on rising edge save in a buffer the previes input and set as output the current input and the previous input
            IF (Ain='1')	THEN			-- if enable bit is on than save the current state
                a <= data_bus;
            ElSE THEN
                a <= a;
            END IF;
        END IF;
END PROCESS;

-------------- monitor b value --------------------
b <= data_bus;

-------------- connect adderSub --------------------
sub <= '1' when OPC="0001" else '0';
carry_in <= '1' when OPC(3 downto 2) ="01" else '0';
AdderSub_pm: AdderSub port map(
    sub => sub,
    carry_in => carry_in,
    a => a,
    b => b,
    result => c,
    carry_out => Cflag
);

-------------- monitor c value --------------------

PROCESS (data_bus, state, clk)
    BEGIN
        IF (rising_edge(clk)) THEN	-- on rising edge save in a buffer the previes input and set as output the current input and the previous input
            IF (cin = '1')	THEN	-- if enable bit is on than save the current state
                c_reg <= c;
            ElSE THEN
                c_reg <= c_reg;
            END IF;
        END IF;

END PROCESS;

-- choose one
data_bus <= c_reg when Cout='1' else 'Z';




END arc_sys;







