------------------------------------------------------------
-- State machine with a metastability problem
-- this machine can stop working if pressing the bthD fast
-- and randomly enough. The way to clear it is to press
-- the btnC button to reset the flip-flops
-- to fix this we need synchronization between the input
-- button press and the 
------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pattern_guesser is
  port (
    CLK100MHZ : in std_logic; -- System clock 
    btnD      : in std_logic;
    btnC      : in std_logic;
    btnR      : in std_logic; 
    btnL      : in std_logic;
    btnU      : in std_logic; 
    sw        : in std_logic_vector (15 downto 0); -- 16 switch inputs
    LED       : out std_logic_vector (15 downto 0); -- 16 leds above switches
    an        : out std_logic_vector (3 downto 0); -- Controls four 7-seg displays
    seg       : out std_logic_vector(6 downto 0); -- 6 leds per display
    dp        : out std_logic -- 1 decimal point per display
  );
end pattern_guesser;

architecture Behavioral of pattern_guesser is


  component synchro is
    Port ( clk : in  STD_LOGIC;
           i :   in  STD_LOGIC;
           q :  out  STD_LOGIC );
  end component;

  signal clk, d, c, l, r, u, first, second, third, fourth, fifth :std_logic; 
  signal sp1, sp2, sp3, sp4, sp5 : std_logic;
  signal y : std_logic_vector(5 downto 0);
  signal reset : std_logic_vector(0 downto 0);

  type statetype is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, SR, GEN);
  signal state, nextstate : statetype := GEN;

begin

  -- read/drive internal signals from/to I/O port
  clk             <= CLK100MHZ;
  reset           <= sw(0 downto 0); -- First switch causes reset
  LED(5 downto 0) <= y; -- Output y shows state

  -- implement the synchronizer for each button
  
  syncD : synchro port map( 
    clk => clk,
    i => btnD,
    q => d
  );
  
  syncC : synchro port map( 
    clk => clk,
    i => btnC,
    q => c
  );
  
  syncL : synchro port map(
    clk => clk,
    i => btnL,
    q => l
  );

  syncR : synchro port map(
    clk => clk,
    i => btnR,
    q => r
  );  

  syncU : synchro port map(
    clk => clk,
    i => btnU,
    q => u
  );

  -- next state combinational logic
  process (nextstate, d, c, l, r, u, state, first, second, third, fourth, fifth, 
           sp1, sp2, sp3, sp4, sp5)
        
  begin
      if rising_edge(clk) then
        -- based on assigned "random" pattern, determine which button signals are first, second, third...
        -- create sp1 assignment
        -- we can get away without else statements here since in GEN, only one of these will ever be selected
        if sp1 = '1' then
            first <= d;
            second <= c;
            third <= l;
            fourth <= r;
            fifth <= u;
        end if;
        if sp2 = '1' then
            first <= c;
            second <= r;
            third <= d;
            fourth <= u;
            fifth <= l;
        end if;
        if sp3 = '1' then
            first <= u;
            second <= r;
            third <= l;
            fourth <= c;
            fifth <= d;
        end if;
        if sp4 = '1' then
            first <= c;
            second <= d;
            third <= l;
            fourth <= u;
            fifth <= r;
        end if;
        if sp5 = '1' then
            first <= l;
            second <= c;
            third <= r;
            fourth <= u;
            fifth <= d;
        end if;
      case state is
      when GEN =>
        -- choose a pattern for someone to guess
       if c = '1' then
            sp1 <= '1';
            sp2 <= '0';
            sp3 <= '0';
            sp4 <= '0';
            sp5 <= '0';
            nextstate <= SR;
       end if;
       if d = '1' then
            sp1 <= '0';
            sp2 <= '1';
            sp3 <= '0';
            sp4 <= '0';
            sp5 <= '0';
            nextstate <= SR;
       end if;
       if l = '1' then
            sp1 <= '0';
            sp2 <= '0';
            sp3 <= '1';
            sp4 <= '0';
            sp5 <= '0';
            nextstate <= SR;
       end if;
       if r = '1' then
            sp1 <= '0';
            sp2 <= '0';
            sp3 <= '0';
            sp4 <= '1';
            sp5 <= '0';
            nextstate <= SR;
       end if;
       if u = '1' then
            sp1 <= '0';
            sp2 <= '0';
            sp3 <= '0';
            sp4 <= '0';
            sp5 <= '1';
            nextstate <= SR;
       end if;
            
      when SR => 
        if first = '0' 
        then nextstate <= S0;
        end if;
      when S0 =>
        if first = '1' 
            then nextstate <= S1;
        else 
            if fifth = '1' or second = '1' or third = '1' or fourth = '1'
            then nextstate  <= SR;
            end if;
        end if;
      when S1 =>
        if first = '0'
            then nextstate <= S2;
        end if;
      when S2 =>
        if second = '1' 
            then nextstate <= S3;
        else  
            if fifth = '1' or first = '1' or third = '1' or fourth = '1'
            then nextstate  <= SR;
            end if;
        end if;
      when S3 =>
        if second = '0'
            then nextstate <= S4;
        end if;
      when S4 =>
        if third = '1' 
            then nextstate <= S5;
        else
            if fifth = '1' or second = '1' or first = '1' or fourth = '1'
            then nextstate  <= SR;
            end if;
        end if;
      when S5 =>
        if third = '0'
            then nextstate <= S6;
        end if;
      when S6 =>
        if fourth = '1' 
            then nextstate <= S7;
        else
            if fifth = '1' or second = '1' or third = '1' or first = '1'
            then nextstate  <= SR;
            end if;
        end if;
      when S7 =>
        if fourth = '0'
            then nextstate <= S8;
        end if;
      when S8 =>    
        if fifth = '1' 
            then nextstate <= S9;
        else
            if first = '1' or second = '1' or third = '1' or fourth = '1'
            then nextstate  <= SR;
            end if;
        end if;
      when S9 =>
        if fifth = '0'
            then nextstate <= S10;
        end if;
      when others =>
        -- add final message?
     end case;
     if reset(0) = '1' then
     state <= GEN;
     else
     state <= nextstate;
     end if;
     end if;
  end process;

  -- each led corresponds to 2 states, since half of the states are just
  -- "guards" for the other ones
  y(0) <= '1' when state = S0 or state = SR else '0'; 
  y(1) <= '1' when state = S2 or state = S1 else '0';
  y(2) <= '1' when state = S4 or state = S3 else '0';
  y(3) <= '1' when state = S6 or state = S5 else '0';
  y(4) <= '1' when state = S8 or state = S7 else '0';
  y(5) <= '1' when state = S10 or state = S9 else '0';

  -- Turn off the 7-segment LEDs
  an  <= "1111"; -- wires supplying power to 4 7-seg displays
  seg <= "1111111"; -- wires connecting each of 7 * 4 segments to ground
  dp  <= '1'; -- wire connects decimal point to ground    
end Behavioral;
