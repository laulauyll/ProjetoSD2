# Esse script compila todos os arquivos .vhd e roda a entidade que deseja
# Para rodar o script, basta digitar no terminal: ./exec.sh
# Altere o nome dos arquivos .vhd e a entidade que deseja rodar


##############################################################################################################
# Compilar todos os arquivos .vhd
ghdl -a -fsynopsys mux.vhd #Adicionar todos os arquivos que deseja compilar
ghdl -a -fsynopsys reg.vhd
ghdl -a -fsynopsys decodificador.vhd
ghdl -a -fsynopsys regfile.vhd
ghdl -a -fsynopsys regfile_tb.vhd

##############################################################################################################
#Entidade que voce quer rodar
ghdl -e -fsynopsys regfile_tb 
ghdl -r -fsynopsys regfile_tb --vcd=simul.vcd #Entidade que voce quer rodar e arquivo saida .vcd pra jogar no gtkwave
##############################################################################################################

# Opcionais de saida
# gtkwave simul.vcd # Rodar o gtkwave

# Remosver arquivos gerados pelo ghdl
# rm *.o 
rm *.cf
# rm *.lst
