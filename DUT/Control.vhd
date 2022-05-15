LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity Control is
    GENERIC (OPC_length : INTEGER := 4);
	port(
        rst, ena, clk: in std_logic;    --from tb
        done: out std_logic;            --to tb
		mov, done_code, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag : in std_logic;  --status
		Cout, Cin, Ain, wrRFen, RFout, IRin, PCin, Imm_in : out std_logic;    --control
        PCsel, RFaddr: out std_logic_vector(1 downto 0);                                    --control
        OPC_in: in std_logic_vector(OPC_length-1 downto 0);                                       --control
        OPC: out std_logic_vector(OPC_length-1 downto 0)                                       --control
    );
end Control;

architecture arc_sys of Control is

-----------logic-------

-- R type
-- 1 - insert ra to RF
-- 2 - rb to RF, Rb to b, b calc with A to C
-- 3 - insert rc to RF + enable writing, cout
-- 4 - done

-- Jmp
-- 1 - pc = pc+offset
-- 2 - done

-- Jc/jnc
-- 1 - if(carry/no carry) pc = pc+offset
-- 2 - done

-- I type
-- 1 - insert ra to writeAddr, wrRFen, immidiet + sign extention to bus,
-- 2 - done

signal opc_type : std_logic_vector(1 downto 0);


--subtype opc_type is  std_logic_vector(1 downto 0);
constant R_type   : std_logic_vector(1 downto 0) := "00";
constant J_type   : std_logic_vector(1 downto 0) := "01";
constant I_type   : std_logic_vector(1 downto 0) := "10";

BEGIN

opc_type <= opc_in(OPC_length-1 downto OPC_length-2);  ---?
PCsel <= "01" when (jmp='1' or (jc='1' and Cflag='1') or (jnc='1' and Cflag='0')) else "10";


FSM_PROC : process(clk)
variable state :integer range 1 to 4 :=1;
begin
    if rst = '1' then
        Cout    <=  '0';
        Cin     <=  '0';
        Ain     <=  '0';
        wrRFen  <=  '0';
        RFout   <=  '0';
        IRin    <=  '0';
        PCin    <=  '0';
        Imm_in  <=  '0';
        RFaddr  <=  "00";
        OPC     <=  "0000";
        done    <=  '0';
        state := 0;

    elsif ena = '0' then
        Cout    <=  '0';
        Cin     <=  '0';
        Ain     <=  '0';
        wrRFen  <=  '0';
        RFout   <=  '0';
        IRin    <=  '0';
        PCin    <=  '0';
        Imm_in  <=  '0';
        RFaddr  <=  "00";
        OPC     <=  "0000";
        done    <=  '0';
        state := state;

    elsif done_code = '1' then
        Cout    <=  '0';
        Cin     <=  '0';
        Ain     <=  '0';
        wrRFen  <=  '0';
        RFout   <=  '0';
        IRin    <=  '0';
        PCin    <=  '0';
        Imm_in  <=  '0';
        RFaddr  <=  "00";
        OPC     <=  "0000";
        done    <=  '1';
        state := 0;

    elsif rising_edge(clk) then
        case state is

            when 1 =>

                if opc_type=R_type then
                -- insert ra to RF, Ra to A
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '1';
                    wrRFen  <=  '0';
                    RFout   <=  '1';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "11";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                elsif opc_type=R_type then
                -- insert ra to RF, Ra to A
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '1';
                    wrRFen  <=  '0';
                    RFout   <=  '1';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                elsif opc_type=J_type then
                -- pc = pc+offset
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '1';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;

                elsif opc_type=I_type then
                -- insert ra to writeAddr, wrRFen, immidiet + sign extention to bus,
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '1';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '1';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                else
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state;
                end if;

            when 2 =>

                if nop='1' then
                -- rb to RF, Rb to b, b calc with A to C
                    Cout    <=  '0';
                    Cin     <=  '1';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '1';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "11";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                elsif opc_type=R_type then
                -- rb to RF, Rb to b, b calc with A to C
                    Cout    <=  '0';
                    Cin     <=  '1';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '1';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "01";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;

                elsif opc_type=J_type then
                -- pc = pc+offset
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '1';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '1';
                    state := 0;

                elsif opc_type=I_type then
                -- insert ra to writeAddr, wrRFen, immidiet + sign extention to bus,
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '1';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '1';
                    state := 0;
                else
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state;

                end if;

            when 3 =>
                if opc_type=R_type then
                -- insert rc to RF + enable writing, cout
                    Cout    <=  '1';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '1';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "11";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                elsif opc_type=R_type then
                -- insert rc to RF + enable writing, cout
                    Cout    <=  '1';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '1';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "10";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state + 1;
                else
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state;
                end if;
            when 4 =>
                if opc_type=R_type then
                -- insert rc to RF + enable writing, cout
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '1';
                    state := 0;
                else
                    Cout    <=  '0';
                    Cin     <=  '0';
                    Ain     <=  '0';
                    wrRFen  <=  '0';
                    RFout   <=  '0';
                    IRin    <=  '0';
                    PCin    <=  '0';
                    Imm_in  <=  '0';
                    RFaddr  <=  "00";
                    OPC     <=  "0000";
                    done    <=  '0';
                    state := state;
                end if;
            end case;
    end if;
end process;

end arc_sys;
