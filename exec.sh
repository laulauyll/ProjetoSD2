ghdl -a -fsynopsys memoriaInstrucoes.vhd
ghdl -a -fsynopsys memoriaDados.vhd
ghdl -a -fsynopsys utils.vhd
ghdl -a -fsynopsys memorias_tb.vhd
ghdl -e -fsynopsys memorias_tb
ghdl -r -fsynopsys memorias_tb --vcd=simul.vcd
# gtkwave simul.vcd
rm *.o *.cf *.lst
