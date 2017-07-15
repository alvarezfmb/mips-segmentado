library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity mux_2_1_5bits is
  port(input0: in std_logic_vector(4 downto 0);
    input1: in std_logic_vector(4 downto 0);
    sel: in std_logic;
    output: out std_logic_vector(4 downto 0));
end mux_2_1_5bits;

architecture mux_2_1_5bits_arch of mux_2_1_5bits is
  begin
  process(input0, input1, sel)
    begin
      if sel = '0' then
        output <= input0;
      else
        output <= input1;
      end if;
    end process;
end mux_2_1_5bits_arch;
