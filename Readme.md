# Final Project Documentation
Class: CS 373 - Digital Logic Design
Group members: Adam Cassidy, Carlos Betancourt, Jeremy Muriungi
Last Modified: 12/03/2021

## Project Description
__PATTERN GUESSER__

__Description and Goal of Hardware__
  Our project idea is a form of Simon says, a pattern guesser.  The program has different established patterns of button presses, and the user will have to start guessing which button is “first” by pressing it.  If a guess is incorrect, it will count as “wrong” and act as a reset, going back to the original state.  Each time the user guesses a button correctly, the LEDs will light up sequentially(starting at LED 0). The goal of the game is for the user to guess the right 5-press pattern and light up LEDs 0-4.  Once this is done, the user can choose another pater to play with. 

__How to Use Hardware__
Once the board is programmed, the user will try and guess the pattern using button presses on the board (BTNU, BTNR, BTND, BTNL, BTNC).
To pick a pattern, flip reset switch on, press any of the five buttons and then flip the reset switch off
If the pattern is, for example, Middle->Right->Left->Up->down (MRLUD), when user presses M button, LED[0] lights up. If the then presses the R button on the board, LED[1] lights up. If the user then presses the U button which is the wrong input for the pattern, the program resets the LEDs and they can start over.

__Assumptions Made__
The main assumption we made was that we would be able to randomize the patterns with no much difficulty. However, we found out that randomization using VHDL is more complex and requires extra libraries and methods. This is why, we decided to hard-code patterns that the user can choose from. This way, we still offer a good user experience.

## Hardware Diagram
<img src="Images/HardwareImplementation.JPG" width="800">

## Moore Machine Diagram
<img src="Images/MooreMachine.JPG" width="800">

## Works Cited
Dr. Kent Jones' slides
