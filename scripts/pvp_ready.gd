extends Control

@onready var p1_ready = $CheckButton1
@onready var p2_ready = $CheckButton2
@onready var ready_time = $ready_time
@onready var timer = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if p1_ready.button_pressed and p2_ready.button_pressed:
		timer.text = "TIMER: " + str(int(ready_time.time_left))
		if ready_time.is_stopped():
			ready_time.start(3)
	else:
		ready_time.stop()
		timer.text = "Ready up"


func _on_ready_time_timeout():
	get_tree().change_scene_to_file("res://scenes/level1_pvp.tscn")
