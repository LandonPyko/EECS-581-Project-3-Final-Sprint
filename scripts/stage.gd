extends Node2D

var timer = Timer.new()
var start_timer = false
#okay so make a timer, wait for it to expire, then clear everything and switch to screen

func stage_clear() -> bool:
	var nodes = get_tree().root.get_children()
	if !start_timer:
		start_timer = true
		timer.start(0.5)
		return false
	elif timer.time_left == 0.0:
		for node in nodes:
			if node.is_in_group("Bullets") or node.is_in_group("Mines"):
				node.free()
		return true
	return false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music()
	timer.one_shot = true
	self.add_child(timer)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var player = get_tree().get_nodes_in_group("Player")
	
	if not $nav_map.is_baking():
		$nav_map.bake_navigation_polygon()
	
	if enemies.is_empty() and player.is_empty():
		if stage_clear():
			get_tree().change_scene_to_file("res://scenes/roundloss.tscn")
	elif enemies.is_empty():	# If no enemies left
		if stage_clear():
			get_tree().change_scene_to_file("res://scenes/roundwin.tscn")
	elif player.is_empty():
		if stage_clear():
			get_tree().change_scene_to_file("res://scenes/roundloss.tscn")
