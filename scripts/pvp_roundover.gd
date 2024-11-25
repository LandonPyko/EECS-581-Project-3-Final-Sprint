extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/start.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void: # Continue button
	Global.current_level += 1
	var next_screen = "res://scenes/level%d_pvp.tscn" % Global.current_level
	if Global.current_level > 10:
		Global.current_level = 0
		next_screen = "res://scenes/main_menu.tscn"
	Global.winner = null
	Global.optionsReturnScreen = null
	print(next_screen)
	get_tree().change_scene_to_file(next_screen)


func _on_options_pressed() -> void: # Options button
	Global.optionsReturnScreen = "res://scenes/player"+str(Global.winner)+"win.tscn"
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")
	


func _on_quit_pressed() -> void: # Menu button
	Global.current_level = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
