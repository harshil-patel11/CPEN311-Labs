onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /keyboard_audio_controller_tb/clk
add wave -noupdate -label key -radix hexadecimal /keyboard_audio_controller_tb/key
add wave -noupdate -label read_ready /keyboard_audio_controller_tb/read_ready
add wave -noupdate -label forward /keyboard_audio_controller_tb/forward
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {97 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 106
configure wave -valuecolwidth 44
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
WaveRestoreZoom {0 ps} {140 ps}
