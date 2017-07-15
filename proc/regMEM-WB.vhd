library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_MEM_WB is
  port(
    -- Entrada
    clk, rst, we : in  std_logic;

    wb_in: in std_logic_vector(1 downto 0);

    read_data_in: in std_logic_vector(31 downto 0);

    alu_address_in: in std_logic_vector(31 downto 0);

    mux_in: in std_logic_vector(4 downto 0);
    
    -- Salida
    wb_out: out std_logic_vector(1 downto 0);

    read_data_out: out std_logic_vector(31 downto 0);

    alu_address_out: out std_logic_vector(31 downto 0);

    mux_out: out std_logic_vector(4 downto 0));

end reg_MEM_WB;

architecture beh of reg_MEM_WB is
begin
  process(clk, rst)
  begin
    if rst = '1' then
      wb_out <= (others => '0');
      read_data_out <= (others => '0');
      alu_address_out <= (others => '0');
      mux_out <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (we = '1') then
      wb_out <= wb_in;
      read_data_out <= read_data_in;
      alu_address_out <= alu_address_in;
      mux_out <= mux_in;
      end if;
    end if;
  end process;
end beh;