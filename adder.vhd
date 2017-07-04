library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Sumador (para calcular potencial direccion de salto. Debe sumar 4 bytes,
-- longitud de cada instruccion de memoria).

entity adder is
    Port (A, B : in std_logic_vector(31 downto 0);
          res    : out std_logic_vector(31 downto 0));
    End;

architecture Behavioral of adder is
    begin
    	res <= A + B;
    end;
