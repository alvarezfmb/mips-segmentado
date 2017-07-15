library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_ID_EX is
  port(
    -- Entrada
    clk, rst, we : in  std_logic;

    wb_in: in std_logic_vector(1 downto 0);
    m_in: in std_logic_vector(2 downto 0);
    ex_in: in std_logic_vector(3 downto 0);

    pc_in: in std_logic_vector(31 downto 0);

    data1_rd_in : in STD_LOGIC_VECTOR (31 downto 0);
    data2_rd_in : in STD_LOGIC_VECTOR (31 downto 0);

    signext_in: in std_logic_vector(31 downto 0);
    
    instr1_in: in std_logic_vector(4 downto 0);
    instr2_in: in std_logic_vector(4 downto 0);
  
    -- Salida

    wb_out: out std_logic_vector(1 downto 0);
    m_out: out std_logic_vector(2 downto 0);
    ex_out: out std_logic_vector(3 downto 0);

    pc_out: out std_logic_vector(31 downto 0);

    data1_rd_out : out STD_LOGIC_VECTOR (31 downto 0);
    data2_rd_out : out STD_LOGIC_VECTOR (31 downto 0);

    signext_out: out std_logic_vector(31 downto 0);
    
    instr1_out: out std_logic_vector(4 downto 0);
    instr2_out: out std_logic_vector(4 downto 0));

end reg_ID_EX;

architecture beh of reg_ID_EX is
begin
  process(clk, rst)
  begin
    if rst = '1' then
      wb_out <= (others => '0');
      m_out <= (others => '0');
      ex_out <= (others => '0');
      pc_out <= (others => '0');
      data1_rd_out <= (others => '0');
      data2_rd_out <= (others => '0');
      signext_out <= (others => '0');
      instr1_out <= (others => '0');
      instr2_out <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (we = '1') then
        wb_out <= wb_in;
        m_out <= m_in;
        ex_out <= ex_in;
        pc_out <= pc_in;
        data1_rd_out <= data1_rd_in;
        data2_rd_out <= data2_rd_in;
        signext_out <= signext_in;
        instr1_out <= instr1_in;
        instr2_out <= instr2_in;
      end if;
    end if;
  end process;
end beh;