ghdl -a -fsynopsys memoriaROM.vhd
ghdl -a -fsynopsys memoriaRAM.vhd
ghdl -a -fsynopsys utils.vhd
ghdl -a -fsynopsys memorias_tb.vhd
ghdl -e -fsynopsys memorias_tb
ghdl -r -fsynopsys memorias_tb --vcd=simul.vcd

# ghdl -a memorias_tb.vhd
# ghdl -e memorias_tb
# ghdl -a -fsynopsys utils.vhd work.utils
# ghdl -r memorias_tb --vcd=simul.vcd
# rm *.o *.cf *.lst
