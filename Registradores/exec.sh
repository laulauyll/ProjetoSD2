ghdl -a -fsynopsys mux.vhd
ghdl -a -fsynopsys reg.vhd
ghdl -a -fsynopsys decodificador.vhd
ghdl -a -fsynopsys regfile.vhd
ghdl -a -fsynopsys regfile_tb.vhd
ghdl -e -fsynopsys regfile_tb
ghdl -r -fsynopsys regfile_tb --vcd=simul.vcd
# gtkwave simul.vcd
# rm *.o *.cf *.lst
