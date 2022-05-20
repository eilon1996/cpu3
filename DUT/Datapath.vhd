LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;

--------------------------------------------------------------
entity DataPath is
    generic(    OPC_length: integer := 4;
                Dwidth: integer := 16;
                Awidth: integer := 6);

    port(       clk, rst, ena  : in std_logic;                                                                  -- basic control
                Cout, Cin, Ain, weRFen, RFout, IRin, PCin, Imm_in, done : in std_logic;                         -- control
                PCsel, RFaddr: in std_logic_vector(1 downto 0);                                                 -- control

                TBactive,RF_writeEn_from_TB, PM_writeEn_from_TB: in std_logic;                                  -- TB controls enable
                PM_dataIn_tb : in std_logic_vector(Dwidth-1 downto 0);                                          -- TB controls data
                RF_write_address_from_TB, RF_read_address_from_TB, PM_write_Addr_tb :                           -- TB controls address
                        in std_logic_vector(Awidth-1 downto 0);

                mov, done_code, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag: out std_logic                 -- status
    );
    end DataPath;
--------------------------------------------------------------

architecture DPArch of DataPath is



--RF
signal RF_write_data, RF_read_data: std_logic_vector(Dwidth-1 downto 0);
signal RF_write_address, RF_read_address: std_logic_vector(Awidth-1 downto 0);
signal RF_writeEn : std_logic;


--program memory
signal PM_readData: std_logic_vector(Dwidth-1 downto 0);
signal PM_writeAddr, PM_readAddr: std_logic_vector(Awidth-1 downto 0);
signal PM_writeEn: std_logic;




--IR
signal IR, RF_addr_from_IR: std_logic_vector(Dwidth-1 downto 0);

signal PC_out: std_logic_vector(Awidth-1 downto 0);
signal BUS_DATA: std_logic_vector(Dwidth-1 downto 0);

signal REG_A, REG_C: std_logic_vector(Dwidth-1 downto 0);

signal RF_writeEn_control: std_logic;
signal PC_to_PM_read_address: std_logic_vector(Dwidth-1 downto 0);


--------------- alias ------------

alias OPC :std_logic_vector(3 downto 0) is IR(15 downto 12);
alias ra : std_logic_vector(3 downto 0) is IR(11 downto 8);
alias rb : std_logic_vector(3 downto 0) is IR(7 downto 4);
alias rc : std_logic_vector(3 downto 0) is IR(3 downto 0);
alias offset : std_logic_vector(4 downto 0) is IR(4 downto 0);
alias immidiet : std_logic_vector(7 downto 0) is IR(7 downto 0);

--subtype opc_type is  std_logic_vector(1 downto 0);
alias OPC_type : std_logic_vector(1 downto 0) is OPC(3 downto 2);


constant R_type   : std_logic_vector(1 downto 0) := "00";
constant J_type   : std_logic_vector(1 downto 0) := "01";
constant I_type   : std_logic_vector(1 downto 0) := "10";


--
constant RFaddr_ra       : std_logic_vector(1 downto 0) := "00";
constant RFaddr_rb       : std_logic_vector(1 downto 0) := "01";
constant RFaddr_rc       : std_logic_vector(1 downto 0) := "10";
constant RFaddr_0        : std_logic_vector(1 downto 0) := "11";



begin

------------- port maps --------------

PC_PM: PC
generic map (Awidth => Awidth, Dwidth => Dwidth, OPC_length=>OPC_length)
port map(
                clk => clk,
                PCin => PCin,
                PCsel => PCsel,
                offset => offset,
                PC_out => PC_to_PM_read_address
);

ProgMem_PM: ProgMem
generic map (Awidth => Awidth, Dwidth => Dwidth, OPC_length=>OPC_length)
port map(
                        clk => clk,
                        PM_writeEn => PM_writeEn_from_TB,
                        PM_dataIn => PM_dataIn_tb,
                        PM_writeAddr => PM_write_Addr_tb,
                        PM_readAddr => PC_to_PM_read_address,
                        PM_readData => PM_readData
);


RF_PM:     RF
generic map (Awidth => Awidth, Dwidth => Dwidth, OPC_length=>OPC_length)
port map(
                        clk => clk,
                        rst => rst,
                        RF_writeEn => RF_writeEn,
                        RF_write_data => BUS_DATA,
                        RF_write_address => RF_write_address,
                        RF_read_address => RF_read_address,
                        RF_read_data => RF_read_data
);

ALU_PM:    ALU
generic map (Awidth => Awidth, Dwidth => Dwidth, OPC_length=>OPC_length)
port map(
                OPC => OPC,
                a => REG_A,
                b => BUS_DATA,
                c => REG_C,
                Cflag => Cflag,
                Zflag => Zflag,
                Nflag => Nflag
);


-------- all 3state ------

BUS_DATA <= REG_C when (Cout = '1') else (others => 'Z');

BUS_DATA <= RF_read_data when (RFout = '1') else (others => 'Z');

BUS_DATA(7 downto 0) <= IR(7 downto 0) when (Imm_in = '1') else (others => 'Z');
BUS_DATA(15 downto 8) <= (others => IR(7)) when (Imm_in = '1') else (others => 'Z');



-------- muxes ------

WITH RFaddr SELECT
RF_addr_from_IR <=      ra   when RFaddr_ra,
                        rb   when RFaddr_rb,
                        rc   when RFaddr_rc,
                        (others=>'0')  when others;



RF_read_address <= RF_read_address_from_TB when TBactive='1' else RF_addr_from_IR;
RF_write_address <= RF_write_address_from_TB when TBactive='1' else RF_addr_from_IR;
RF_writeEn <= RF_writeEn_from_TB when TBactive='1' else RF_writeEn_control;

IR <= PM_readData when IRin = '1' else UNAFFECTED;


datapath_process: process(clk)

begin

OPC_Decoder:
case IR(15 downto 12) is                -- IR(15:12) are OPC bits
        when "0000" =>
                add <= '1';
                mov <= '0';
                done_code <= '0';
                nop <= '0';
                jnc <= '0';
                jc <= '0';
                jmp <= '0';
                sub <= '0';
        when "0001" =>
                add <= '0';
                mov <= '0';
                done_code <= '0';
                nop <= '0';
                jnc <= '0';
                jc <= '0';
                jmp <= '0';
                sub <= '1';
        when "0010" =>
                add <= '0';
                mov <= '0';
                done_code <= '0';
                nop <= '1';
                jnc <= '0';
                jc <= '0';
                jmp <= '0';
                sub <= '0';
        when "0011" =>
                add <= '0';
                mov <= '0';
                done_code <= '0';
                nop <= '0';
                jnc <= '0';
                jc <= '0';
                jmp <= '0';
                sub <= '0';
        when "0100" =>
                add <= '0';
                mov <= '0';
                done_code <= '0';
                nop <= '0';
                jnc <= '0';
                jc <= '0';
                jmp <= '1';
                sub <= '0';
        when "0101" =>
                add <= '0';
                mov <= '0';
                done_code <= '0';
                nop <= '0';
                jnc <= '0';
                jc <= '1';
                jmp <= '0';
                sub <= '0';
        when "0110" =>
                add <= '0';
                mov <= '0';
                done_code <= '0';
                nop <= '0';
                jnc <= '1';
                jc <= '0';
                jmp <= '0';
                sub <= '0';
        when "0111" =>
                add <= '0';
                mov <= '0';
                done_code <= '0';
                nop <= '0';
                jnc <= '0';
                jc <= '0';
                jmp <= '0';
                sub <= '0';
        when "1000" =>
                add <= '0';
                mov <= '1';
                done_code <= '0';
                nop <= '0';
                jnc <= '0';
                jc <= '0';
                jmp <= '0';
                sub <= '0';
        when "1001" =>
                add <= '0';
                mov <= '0';
                done_code <= '1';
                nop <= '0';
                jnc <= '0';
                jc <= '0';
                jmp <= '0';
                sub <= '0';
      when others =>

                add <= '0';
                mov <= '0';
                done_code <= '0';
                nop <= '0';
                jnc <= '0';
                jc <= '0';
                jmp <= '0';
                sub <= '0';
end case;




-------- muxes ------




        if (rising_edge(clk)) then
          if(Ain = '1' ) then REG_A <= BUS_DATA; end if;
          if(Cin = '1' ) then REG_C <= BUS_DATA; end if;
      end if;


end process;


end DPArch;
