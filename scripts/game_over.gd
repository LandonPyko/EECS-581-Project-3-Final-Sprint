extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/quit.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_quit_pressed() -> void: # Menu button
	Global.current_level = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
