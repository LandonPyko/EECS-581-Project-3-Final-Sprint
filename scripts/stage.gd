extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var player = get_tree().get_nodes_in_group("Player")
	
	if not $nav_map.is_baking():
		$nav_map.bake_navigation_polygon()
	
	if enemies.is_empty():	# If no enemies left
		
		get_tree().change_scene_to_file("res://scenes/roundwin.tscn")
	if player.is_empty():
		get_tree().change_scene_to_file("res://scenes/roundloss.tscn")
