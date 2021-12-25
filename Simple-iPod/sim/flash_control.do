onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /flash_control_tb/clk
add wave -noupdate -label start_flash_read /flash_control_tb/start_flash_read
add wave -noupdate -label mem_read /flash_control_tb/mem_read
add wave -noupdate -label valid_read /flash_control_tb/valid_read
add wave -noupdate -label wait_request /flash_control_tb/wait_request
add wave -noupdate -label end_flash_read /flash_control_tb/end_flash_read
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
WaveRestoreZoom {12 ps} {117 ps}
