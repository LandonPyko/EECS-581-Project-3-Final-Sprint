extends Control

func _ready() -> void:
	$VBoxContainer/HBoxContainer/easy.grab_focus()

func _on_easy_pressed() -> void:
	Global.difficulty = "easy"
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_medium_pressed() -> void:
	Global.difficulty = "medium"
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_hard_pressed() -> void:
	Global.difficulty = "hard"
	get_tree().change_scene_to_file("res://scenes/level1.tscn")
