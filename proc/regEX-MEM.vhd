library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_EX_MEM is
  port(
    -- Entrada
    clk, rst, we : in  std_logic;

    wb_in: in std_logic_vector(1 downto 0);
    m_in: in std_logic_vector(2 downto 0);

    pc_in: in std_logic_vector(31 downto 0);

    alu_zero_in: in std_logic;
    alu_res_in: in std_logic_vector(31 downto 0);

    data2_rd_in : in std_logic_vector (31 downto 0);

    mux_in: in std_logic_vector(4 downto 0);

    -- Salida
    wb_out: out std_logic_vector(1 downto 0);
    m_out: out std_logic_vector(2 downto 0);

    pc_out: out std_logic_vector(31 downto 0);

    alu_zero_out: out std_logic;
    alu_res_out: out std_logic_vector(31 downto 0);

    data2_rd_out : out std_logic_vector (31 downto 0);

    mux_out: out std_logic_vector(4 downto 0));

end reg_EX_MEM;

architecture beh of reg_EX_MEM is
begin
  process(clk, rst)
  begin
    if rst = '1' then
      wb_out <= (others => '0');
      m_out <= (others => '0');
      pc_out <= (others => '0');
      alu_zero_out <= '0';
      alu_res_out <= (others => '0');
      data2_rd_out <= (others => '0');
      mux_out <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (we = '1') then
        wb_out <= wb_in;
        m_out <= m_in;
        pc_out <= pc_in;
        alu_zero_out <= alu_zero_in;
        alu_res_out <= alu_res_in;
        data2_rd_out <= data2_rd_in;
        mux_out <= mux_in;
      end if;
    end if;
  end process;
end beh;