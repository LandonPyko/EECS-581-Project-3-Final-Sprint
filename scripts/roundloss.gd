extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music()
	$VBoxContainer/retry.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Global.temp_score = 0



func _on_options_pressed() -> void: # Options button
	Global.optionsReturnScreen = "res://scenes/roundloss.tscn"
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_quit_pressed() -> void:
	Global.current_level = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_retry_pressed() -> void:
	var next_screen = "res://scenes/level%d.tscn" % Global.current_level
	get_tree().change_scene_to_file(next_screen)
