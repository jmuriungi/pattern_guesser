#!/bin/bash

if ! command -v vivado &> /dev/null
then
    if [ -d /c/Xilinx/Vivado/2019.1/bin ] 
    then
        echo "Found Vivado 2019.1. Running script..."
        vhdl=/c/Xilinx/Vivado/2019.1/bin/
    elif [ -d /c/Xilinx/Vivado/2020.1/bin ]
    then
        echo "Found Vivado 2020.1. Running script..."
        vhdl=/c/Xilinx/Vivado/2020.1/bin/
    elif [ -d /c/Xilinx/Vivado/2021.2/bin ]
    then
        echo "Found Vivado 2021.2. Running script..."
        vhdl=/c/Xilinx/Vivado/2021.2/bin/
    else
        echo "Edit this script, gen.sh"
        echo "and follow the comments in there to set the path to vivado correctly"
        # edit the following line and make sure the path  to vivado is correct
        vhdl=/c/Xilinx/Vivado/2020.2/bin/
    fi
    PATH=$PATH:$vhdl
fi

vivado -mode batch -source ./setup_project.tcl