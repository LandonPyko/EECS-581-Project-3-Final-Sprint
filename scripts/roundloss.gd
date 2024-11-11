extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.temp_score = 0

func _on_start_pressed()->void:
	
	var next_screen = "res://scenes/level%d.tscn" % Global.current_level
	print(next_screen)
	get_tree().change_scene_to_file(next_screen)
