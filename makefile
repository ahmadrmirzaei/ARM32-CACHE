all:
	iverilog -o build/build1 testbench/testbench1.sv
	iverilog -o build/build2 testbench/testbench2.sv

	vvp build/build1 > logs/log1.txt
	cat build/registers.txt >> logs/log1.txt
	cat build/cache.txt >> logs/log1.txt
	cat build/memory.txt >> logs/log1.txt

	vvp build/build2 > logs/log2.txt
	cat build/registers.txt >> logs/log2.txt
	cat build/cache.txt >> logs/log2.txt
	cat build/memory.txt >> logs/log2.txt

	rm -f vivado/*.log
	rm -f vivado/*.jou
	vivado -mode batch -source vivado/vivado.tcl \
	-tempDir vivado \
	-log vivado/vivado.log \
	-jou vivado/vivado.jou