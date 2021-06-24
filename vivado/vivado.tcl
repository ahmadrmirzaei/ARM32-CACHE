read_verilog -sv ./dataPath.sv

synth_design -top dataPath -part xc7vx485tffg1157-1
report_utilization -file ./vivado/util.rpt
report_timing -file ./vivado/timing.rpt
write_verilog -force ./vivado/ver.v
start_gui
