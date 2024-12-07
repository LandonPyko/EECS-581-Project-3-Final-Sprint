extends Node

var tank1_Color    = Color.BLUE
var bullet1_Color  = Color.ANTIQUE_WHITE
var tank2_Color    = Color.BLUE
var bullet2_Color  = Color.ANTIQUE_WHITE
var temp_score    = 0
var score 		  = 0
var p1_score 	  = 0
var p2_score 	  = 0
var current_level = 0
var difficulty    = "pvp" # placeholder for return button in options menu
var winner = null #var that will inform code which player won the round
var optionsReturnScreen = null #var that lets game know what screen to go back to after returning from options

func set_bus_volume(bus_index, value) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)
