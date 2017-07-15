library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity processor is
port(
	Clk         : in  std_logic;
	Reset       : in  std_logic;
	-- Instruction memory
	I_Addr      : out std_logic_vector(31 downto 0);
	I_RdStb     : out std_logic;
	I_WrStb     : out std_logic;
	I_DataOut   : out std_logic_vector(31 downto 0);
	I_DataIn    : in  std_logic_vector(31 downto 0);
	-- Data memory
	D_Addr      : out std_logic_vector(31 downto 0);
	D_RdStb     : out std_logic;
	D_WrStb     : out std_logic;
	D_DataOut   : out std_logic_vector(31 downto 0);
	D_DataIn    : in  std_logic_vector(31 downto 0)
);
end processor;

architecture processor_arq of processor is 

-- Declaracion de componentes

-- Etapa IF
component program_counter port (clk, rst, we: in std_logic;
          input: in std_logic_vector(31 downto 0);
          output: out std_logic_vector(31 downto 0));
end component;

component adder port (A, B: in std_logic_vector(31 downto 0);
          res: out std_logic_vector(31 downto 0));
end component;

component reg_IF_ID port (clk, rst, we : in  std_logic;
		      pc_plus_4_IF, inst_IF: in  std_logic_vector(31 downto 0);
		      pc_plus_4_ID, inst_ID: out std_logic_vector(31 downto 0));
end component;

component mux_2_1_32bits port(input0: in std_logic_vector(31 downto 0);
          input1: in std_logic_vector(31 downto 0);
          sel: in std_logic;
          output: out std_logic_vector(31 downto 0));
end component;

-- Etapa ID
component Registers port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           wr : in STD_LOGIC;
           reg1_dr : in STD_LOGIC_VECTOR (4 downto 0);
           reg2_dr : in STD_LOGIC_VECTOR (4 downto 0);
           reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
           data_wr : in STD_LOGIC_VECTOR (31 downto 0);
           data1_rd : out STD_LOGIC_VECTOR (31 downto 0);
           data2_rd : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component sign_extension port(A : in  std_logic_vector(15 downto 0);
	          Y : out std_logic_vector(31 downto 0));
end component;

component control_unit port(OP : in  STD_LOGIC_VECTOR(5 downto 0);
		        EX_signals: out STD_LOGIC_VECTOR(3 downto 0);
		        MEM_signals: out STD_LOGIC_VECTOR(2 downto 0);
		        WB_signals: out STD_LOGIC_VECTOR(1 downto 0));
end component;

component reg_ID_EX port(clk, rst, we: in  std_logic;
            wb_in: in std_logic_vector(1 downto 0);
            m_in: in std_logic_vector(2 downto 0);
            ex_in: in std_logic_vector(3 downto 0);
            pc_in: in std_logic_vector(31 downto 0);
            data1_rd_in : in STD_LOGIC_VECTOR (31 downto 0);
            data2_rd_in : in STD_LOGIC_VECTOR (31 downto 0);
            signext_in: in std_logic_vector(31 downto 0);
            instr1_in: in std_logic_vector(4 downto 0);
            instr2_in: in std_logic_vector(4 downto 0);
            wb_out: out std_logic_vector(1 downto 0);
            m_out: out std_logic_vector(2 downto 0);
            ex_out: out std_logic_vector(3 downto 0);
            pc_out: out std_logic_vector(31 downto 0);
            data1_rd_out : out STD_LOGIC_VECTOR (31 downto 0);
            data2_rd_out : out STD_LOGIC_VECTOR (31 downto 0);
            signext_out: out std_logic_vector(31 downto 0);
            instr1_out: out std_logic_vector(4 downto 0);
            instr2_out: out std_logic_vector(4 downto 0));
end component;

-- Etapa EX
component shiftLeft2 port(input  :in  std_logic_vector(31 downto 0);
		       output :out std_logic_vector(31 downto 0));
end component;

component ALU port( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           control : in STD_LOGIC_VECTOR (2 downto 0);
           zero : out STD_LOGIC;
           result : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component alu_control port(f      : in  STD_LOGIC_VECTOR(5 downto 0);
          alu_op : in  std_logic_vector(1 downto 0);
          alu_in : out std_logic_vector(2 downto 0));
end component;

component mux_2_1_5bits port(input0: in std_logic_vector(4 downto 0);
          input1: in std_logic_vector(4 downto 0);
          sel: in std_logic;
          output: out std_logic_vector(4 downto 0));
end component;

component reg_EX_MEM port(clk, rst, we : in  std_logic;
          wb_in: in std_logic_vector(1 downto 0);
          m_in: in std_logic_vector(2 downto 0);
          pc_in: in std_logic_vector(31 downto 0);
          alu_zero_in: in std_logic;
          alu_res_in: in std_logic_vector(31 downto 0);
          data2_rd_in : in std_logic_vector (31 downto 0);
          mux_in: in std_logic_vector(4 downto 0);
          wb_out: out std_logic_vector(1 downto 0);
          m_out: out std_logic_vector(2 downto 0);
          pc_out: out std_logic_vector(31 downto 0);
          alu_zero_out: out std_logic;
          alu_res_out: out std_logic_vector(31 downto 0);
          data2_rd_out : out std_logic_vector (31 downto 0);
          mux_out: out std_logic_vector(4 downto 0));
end component;

-- Etapa MEM
component reg_MEM_WB port(clk, rst, we : in  std_logic;
          wb_in: in std_logic_vector(1 downto 0);
          read_data_in: in std_logic_vector(31 downto 0);
          alu_address_in: in std_logic_vector(31 downto 0);
          mux_in: in std_logic_vector(4 downto 0);
          wb_out: out std_logic_vector(1 downto 0);
          read_data_out: out std_logic_vector(31 downto 0);
          alu_address_out: out std_logic_vector(31 downto 0);
          mux_out: out std_logic_vector(4 downto 0));
end component;

-- Declaracion de señales

-- Etapa IF
-- Contador de programa
signal pc_in: std_logic_vector(31 downto 0);
signal pc_out: std_logic_vector(31 downto 0);

-- Sumador PC+4
signal pc_plus_4: std_logic_vector(31 downto 0);

--Etapa ID
-- Salidas de registro IF/ID
signal instruction_ID : std_logic_vector(31 downto 0);
signal pc_ID : std_logic_vector(31 downto 0);

-- Salidas de banco de registros
signal reg_data_1: std_logic_vector(31 downto 0);
signal reg_data_2: std_logic_vector(31 downto 0);

-- Extension de signo
signal sign_extended_ID: std_logic_vector(31 downto 0);

-- Salidas de unidad de control
signal EXsignals_ID: std_logic_vector(3 downto 0);
signal MEMsignals_ID: std_logic_vector(2 downto 0);
signal WBsignals_ID: std_logic_vector(1 downto 0);

-- Etapa EX
-- Salidas de registro ID/EX
signal EXsignals_EX: std_logic_vector(3 downto 0);
signal MEMsignals_EX: std_logic_vector(2 downto 0);
signal WBsignals_EX: std_logic_vector(1 downto 0);
signal pc_out_EX: std_logic_vector(31 downto 0);
signal data1_rd_EX: STD_LOGIC_VECTOR (31 downto 0);
signal data2_rd_EX: STD_LOGIC_VECTOR (31 downto 0);
signal signext_out_EX: std_logic_vector(31 downto 0);
signal instr1_out_EX: std_logic_vector(4 downto 0);
signal instr2_out_EX: std_logic_vector(4 downto 0);

-- Shift left 2
signal shift_out: std_logic_vector(31 downto 0);

-- Sumador de direccion de salto
signal pc_branch_EX: std_logic_vector(31 downto 0);

-- Salida mux segundo operador de ALU
signal alu_operator2: std_logic_vector(31 downto 0);

-- Salida de control de ALU:
signal alu_ctrl_out: std_logic_vector(2 downto 0);

-- Salidas de ALU:
signal alu_zero_EX: std_logic;
signal alu_result_EX: std_logic_vector(31 downto 0);

-- salida mux registro destino:
signal reg_dst_EX: std_logic_vector(4 downto 0);

-- Etapa MEM
-- Salidas de registro EX/MEM
signal MEMsignals_MEM: std_logic_vector(2 downto 0);
signal WBsignals_MEM: std_logic_vector(1 downto 0);
signal pc_branch_MEM: std_logic_vector(31 downto 0);
signal alu_zero_MEM: std_logic;
signal alu_res_MEM: std_logic_vector(31 downto 0);
signal data2_rd_MEM: std_logic_vector(31 downto 0);
signal reg_dst_MEM: std_logic_vector(4 downto 0);
signal pc_src: std_logic;

-- Etapa WB
-- Salidas de registro MEM/WB
signal WBsignals_WB: std_logic_vector(1 downto 0);
signal alu_res_WB: std_logic_vector(31 downto 0);
signal mem_data_WB: std_logic_vector(31 downto 0);
signal reg_dst_WB: std_logic_vector(4 downto 0);

-- Salida mux de datos
signal reg_data_write: std_logic_vector(31 downto 0);
  
begin 	

-- Instanciacion de componentes

-- Etapa IF
pc: program_counter port map(clk => Clk, rst => Reset, we => '1', input => pc_in, output => pc_out);
  
adder_plus_4: adder port map(A => pc_out, B => X"00000004", res => pc_plus_4);
  
reg_IFID: reg_IF_ID port map(clk => Clk, rst => Reset, we => '1', pc_plus_4_IF => pc_plus_4, inst_IF => I_DataIn, 
                    pc_plus_4_ID => pc_ID, inst_ID => instruction_ID);
                    
mux_pc: mux_2_1_32bits port map(input0 => pc_plus_4, input1 => pc_plus_4, sel => '0', output => pc_in);
  
-- Etapa ID
banco_reg: Registers port map(clk => Clk, reset => Reset, wr => WBsignals_WB(1), reg1_dr => instruction_ID(25 downto 21), 
           reg2_dr => instruction_ID(20 downto 16), reg_wr => reg_dst_WB , data_wr => reg_data_write, data1_rd => reg_data_1, data2_rd => reg_data_2);

sign_extend: sign_extension port map(A => instruction_ID(15 downto 0), Y => sign_extended_ID);

control: control_unit port map(OP => instruction_ID(31 downto 26), EX_signals => EXsignals_ID,
          MEM_signals => MEMsignals_ID, WB_signals => WBsignals_ID);

reg_IDEX: reg_ID_EX port map(clk => Clk, rst => Reset, we => '1', wb_in => WBsignals_ID,
          m_in => MEMsignals_ID, ex_in => EXsignals_ID, pc_in => pc_ID, data1_rd_in => reg_data_1,
          data2_rd_in => reg_data_2, signext_in => sign_extended_ID, instr1_in => instruction_ID(20 downto 16),
          instr2_in => instruction_ID(15 downto 11), wb_out => WBsignals_EX, m_out => MEMsignals_EX,
          ex_out => EXsignals_EX, pc_out => pc_out_EX, data1_rd_out => data1_rd_EX, data2_rd_out => data2_rd_EX,
          signext_out => signext_out_EX, instr1_out => instr1_out_EX, instr2_out => instr2_out_EX);

-- Etapa EX
shift_left: shiftLeft2 port map(input => signext_out_EX, output => shift_out);
  
adder_branch: adder port map(A => pc_out_EX, B => shift_out, res => pc_branch_EX);
  
mux_alu: mux_2_1_32bits port map(input0 => data2_rd_EX, input1 => signext_out_EX, sel => EXsignals_EX(2), output => alu_operator2);
  
ctrl_alu: alu_control port map(f => signext_out_EX(5 downto 0), alu_op => EXsignals_EX(1 downto 0), alu_in => alu_ctrl_out);
  
ual: ALU port map(a => data1_rd_EX, b => alu_operator2, control => alu_ctrl_out, zero => alu_zero_EX, result => alu_result_EX);
  
mux_rt_rd: mux_2_1_5bits port map(input0 => instr1_out_EX, input1 => instr2_out_EX, sel => EXsignals_EX(3), output => reg_dst_EX);
  
reg_EXMEM: reg_EX_MEM port map(clk => Clk, rst => Reset, we => '1', wb_in => WBsignals_EX,
          m_in => MEMsignals_EX, pc_in => pc_branch_EX, alu_zero_in => alu_zero_EX, alu_res_in => alu_result_EX,
          data2_rd_in => data2_rd_EX, mux_in => reg_dst_EX, wb_out => WBsignals_MEM, m_out => MEMsignals_MEM, pc_out => pc_branch_MEM,
          alu_zero_out => alu_zero_MEM, alu_res_out => alu_res_MEM, data2_rd_out => data2_rd_MEM, mux_out => reg_dst_MEM);

-- Etapa MEM
reg_MEMWB: reg_MEM_WB port map(clk => Clk, rst => Reset, we => '1', wb_in => WBsignals_MEM,
          read_data_in => D_DataIn, alu_address_in => alu_res_MEM, mux_in => reg_dst_MEM,
          wb_out => WBsignals_WB, read_data_out => mem_data_WB, alu_address_out => alu_res_WB, mux_out => reg_dst_WB);
          
-- Etapa WB
mux_data_WB: mux_2_1_32bits port map(input0 => alu_res_WB, input1 => mem_data_WB, sel => WBsignals_WB(0), output => reg_data_write);

I_Addr <= pc_out;
I_RdStb <= '1';
I_WrStb <= '0';
D_Addr <= alu_res_MEM;
D_RdStb <= MEMsignals_MEM(1);
D_WrStb <= MEMsignals_MEM(0);
D_DataOut <= data2_rd_MEM;
pc_src <= alu_zero_MEM and MEMsignals_MEM(2);

 
end processor_arq;
