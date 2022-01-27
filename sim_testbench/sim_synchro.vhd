library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;   -- for UNIFORM (random number generator), TRUNC functions

entity sim_synchro IS
end sim_synchro;
 
architecture sim_synchro OF sim_synchro IS 
    -- Component Declaration for the Unit Under Test (UUT)
    component synchro
    port(
         clk : IN  std_logic;
         i : IN  std_logic;
         q : OUT  std_logic
        );
    end component;

    --Inputs
    signal clk : std_logic := '0';
    signal i : std_logic := '0';
    --Outputs
    signal q : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;
 
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: synchro port map (
          clk => clk,
          i => i,
          q => q
        );

    -- Clock process definitions
    clk_process : process 
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
        variable seed1 : positive := 13; -- seed values for ran num gen
        variable seed2 : positive := 7; -- seed values for ran num gen      
        variable rand : real; -- random real value in range 0.0 to 1.0
        variable int_rand : integer; -- random value integer
        variable ran_wait_time: time;  -- random wait duration
    begin       
        --d <= NOT d;
        --wait for 5 ns;
        --d <= NOT d;       
        --wait for clk_period;
        --d <= NOT d;       
        --wait for clk_period;        
        uniform(seed1, seed2, rand); -- generate a random number
        -- rescale and save integer portion
        int_rand := INTEGER( trunc( rand * 10.0 ) ); 
        -- compute random wait
        ran_wait_time := (100ps +(int_rand*100 ps)); 
        wait for ran_wait_time; -- wait for our random duration
        i <= NOT i; -- Toggle the input to the synchronizer  
    end process;

end sim_synchro;
