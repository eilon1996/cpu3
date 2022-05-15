LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;

--------------------------------------------------------------
entity DataPath is
    generic( m: integer := 16;
             n: integer := 16);

    port(   clk, rst,Cout, Cin, Ain, weRFen, RFout, IRin, PCin, PCsel, Imm_in: in std_logic;
            OPC: in std_logic_vector(3 downto 0);
            RFaddr: in std_logic_vector(2 downto 0);
            mov, done, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag: out std_logic;
            memDataIn:	in std_logic_vector(m-1 downto 0);
            rfDataIn :  in std_logic_vector(n-1 downto 0);
            rfDataOut: 	out std_logic_vector(n-1 downto 0)
    );
    end DataPath;
--------------------------------------------------------------

architecture DPArch of DataPath is

signal IR, IR_output: std_logic_vector(n-1 downto 0);
signal tempReg: std_logic_vector(3 downto 0) ;
signal PC_buffer: std_logic_vector(n-1 downto 0);
signal BUS_DATA: std_logic_vector(n-1 downto 0);
signal BUS_DATA_WRITE_FROM_RF: std_logic_vector(n-1 downto 0);
signal BUS_DATA_WRITE_FROM_ALU: std_logic_vector(n-1 downto 0);

signal REG_A: std_logic;
signal REG_C: std_logic;
        process(clk)

        begin

        getPC: PC port map(
                        clk => clk,
                        PCin => PCin,
                        PCsel => PCsel,
                        offset => IR (4 downto 0),
                        PC_out => PC_buffer
        );

        wProgMem: ProgMem port map(
                                clk => clk,
                                memEn => '1',
                                WmemData => memDataIn,
                                RmemAddr => PC_buffer,
                                WmemAddr => XXX,
                                RmemData => IR
        );

        IR_output <= IR when IRin = '1' else UNAFFECTED;

        OPC_Decoder:
                        case IR_output(15 downto 12) is                -- IR(15:12) are OPC bits
                                when "0000" =>
                                        add <= '1';
                                        mov <= '0';
                                        done <= '0';
                                        nop <= '0';
                                        jnc <= '0';
                                        jc <= '0';
                                        jmp <= '0';
                                        sub <= '0';
                                        add <= '0';
                                when "0001" =>
                                        add <= '0';
                                        mov <= '0';
                                        done <= '0';
                                        nop <= '0';
                                        jnc <= '0';
                                        jc <= '0';
                                        jmp <= '0';
                                        sub <= '1';
                                        add <= '0';
                                when "0010" =>
                                        add <= '0';
                                        mov <= '0';
                                        done <= '0';
                                        nop <= '1';
                                        jnc <= '0';
                                        jc <= '0';
                                        jmp <= '0';
                                        sub <= '0';
                                        add <= '0';
                                when "0011" =>
                                        add <= '0';
                                        mov <= '0';
                                        done <= '0';
                                        nop <= '0';
                                        jnc <= '0';
                                        jc <= '0';
                                        jmp <= '0';
                                        sub <= '0';
                                        add <= '0';
                                when "0100" =>
                                        add <= '0';
                                        mov <= '0';
                                        done <= '0';
                                        nop <= '0';
                                        jnc <= '0';
                                        jc <= '0';
                                        jmp <= '1';
                                        sub <= '0';
                                        add <= '0';
                                when "0101" =>
                                        add <= '0';
                                        mov <= '0';
                                        done <= '0';
                                        nop <= '0';
                                        jnc <= '0';
                                        jc <= '1';
                                        jmp <= '0';
                                        sub <= '0';
                                        add <= '0';
                                when "0110" =>
                                        add <= '0';
                                        mov <= '0';
                                        done <= '0';
                                        nop <= '0';
                                        jnc <= '1';
                                        jc <= '0';
                                        jmp <= '0';
                                        sub <= '0';
                                        add <= '0';
                                when "0111" =>
                                        add <= '0';
                                        mov <= '0';
                                        done <= '0';
                                        nop <= '0';
                                        jnc <= '0';
                                        jc <= '0';
                                        jmp <= '0';
                                        sub <= '0';
                                        add <= '0';
                                when "1000" =>
                                        add <= '0';
                                        mov <= '1';
                                        done <= '0';
                                        nop <= '0';
                                        jnc <= '0';
                                        jc <= '0';
                                        jmp <= '0';
                                        sub <= '0';
                                        add <= '0';
                                when "1001" =>
                                        add <= '0';
                                        mov <= '0';
                                        done <= '1';
                                        nop <= '0';
                                        jnc <= '0';
                                        jc <= '0';
                                        jmp <= '0';
                                        sub <= '0';
                                        add <= '0';
                        end case;

        SIGN_EXT:

                BUS_DATA(7 downto 0) <= IR_output(7 downto 0) when (Imm_in = '1') else (others => 'Z');
                BUS_DATA(15 downto 8) <= (others => IR_output(7)) when (Imm_in = '1') else (others => 'Z');

        REG_MUX:        case RFaddr is
                                when "00" =>
                                        tempReg <= IR_output(11 downto 8); -- ra selected
                                when "01" =>
                                        tempReg <= IR_output(7 downto 4);  -- rb selected
                                when "10" =>
                                        tempReg <= IR_output(3 downto 0);  -- rc selected
                        end case;


        RF:     RF port map(
                                clk => clk,
                                rst => rst,
                                WregEn => wrRFen,
                                WregData => BUS_DATA,
                                WregAddr => tempReg,
                                RregAddr => tempReg,
                                RregData => BUS_DATA_WRITE_FROM_RF
        );

        BUS_DATA <= BUS_DATA_WRITE_FROM_RF when (RFout = '1') else (others => 'Z');

        if (rising_edge(clk)) then
                REG_A <= BUS_DATA when (Ain = '1' ) else (others =>'Z');
        end if;

        ALU_f:    ALU port map(
                        OPC => IR_output(15 downto 12),
                        a => REG_A,
                        b => BUD_DATA,
                        c => REC_C
        );

        if (rising_edge(clk)) then
                REG_C <= BUS_DATA when (Cin = '1' ) else (others =>'Z');
        end if;

        BUS_DATA <= REG_C when (Cout = '1') else (others => 'Z');

        end process;

        end


       \ type RAM is array (0 to dept-1) of
                std_logic_vector(Dwidth-1 downto 0);
        signal sysRAM: RAM;

        begin
                process(clk)
                begin
                if (clk'event and clk='1') then
                        if (memEn='1') then
                                -- index is type of integer so we need to use
                                -- buildin function conv_integer in order to change the type
                                -- from std_logic_vector to integer
                                sysRAM(conv_integer(WmemAddr)) <= WmemData;
                        end if;
                end if;
                end process;

                RmemData <= sysRAM(conv_integer(RmemAddr));
        \
end DPArch;
