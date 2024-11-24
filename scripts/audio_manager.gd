extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play_music():
	if Global.current_level > 1:
		pitch_scale = 0.1 * Global.current_level + 1
	if not is_playing():
		play()

func stop_music():
	stop()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
