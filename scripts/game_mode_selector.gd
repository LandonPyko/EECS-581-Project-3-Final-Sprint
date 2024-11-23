extends Control

func _ready() -> void:
	$VBoxContainer/HBoxContainer/pve.grab_focus()
	AudioManager.play_music()

func _on_pvp_pressed() -> void:
	Global.current_level = 1
	Global.p1_score = 0
	Global.p2_score = 0
	Global.difficulty = "pvp"
	get_tree().change_scene_to_file("res://scenes/level1_pvp.tscn")


func _on_pve_pressed() -> void:
	Global.current_level = 1
	Global.score = 0
	Global.temp_score = 0
	get_tree().change_scene_to_file("res://scenes/difficulty_selector.tscn")
