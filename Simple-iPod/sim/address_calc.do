onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /address_calc_tb/clk
add wave -noupdate -label sync_clk /address_calc_tb/sync_clk
add wave -noupdate -label play /address_calc_tb/play
add wave -noupdate -label forward /address_calc_tb/forward
add wave -noupdate -label end_flash_read /address_calc_tb/end_flash_read
add wave -noupdate -label start_flash /address_calc_tb/start_flash
add wave -noupdate -label read /address_calc_tb/read
add wave -noupdate -label finish /address_calc_tb/finish
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {105 ps}
