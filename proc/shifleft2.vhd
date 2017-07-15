library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Shift left de dos posiciones: multiplica por cuatro el valor de entrada.

entity shiftLeft2 is 
    port(
	    input  :in  std_logic_vector(31 downto 0);
		  output :out std_logic_vector(31 downto 0)
    );
end entity;

architecture behavioral of shiftLeft2 is 
	begin
        process(input) begin 
		    output(31 downto 2) <= input(29 downto 0);
		    output(1 downto 0) <= "00";
		end process;
end architecture;