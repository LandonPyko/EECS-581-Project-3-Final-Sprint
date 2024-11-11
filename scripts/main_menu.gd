extends Control

func _on_start_pressed() -> void:
	Global.current_level = 1
	Global.score = 0
	Global.temp_score = 0
	get_tree().change_scene_to_file("res://scenes/difficulty_selector.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
