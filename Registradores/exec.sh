ghdl -a -fsynopsys mux.vhd #Adicionar todos os arquivos que deseja compilar
ghdl -a -fsynopsys reg.vhd
ghdl -a -fsynopsys decodificador.vhd
ghdl -a -fsynopsys regfile.vhd
ghdl -a -fsynopsys regfile_tb.vhd
ghdl -e -fsynopsys regfile_tb #Entidade que voce quer rodar
ghdl -r -fsynopsys regfile_tb --vcd=simul.vcd #Entidade que voce quer rodar e arquivo saida .vcd pra jogar no gtkwave
# gtkwave simul.vcd
# rm *.o 
rm *.cf #Arquivo gerado pelo ghdl se não quiser só comentar
# rm *.lst
