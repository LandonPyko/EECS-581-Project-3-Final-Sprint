extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player1 = get_tree().get_nodes_in_group("Player1")
	var player2 = get_tree().get_nodes_in_group("Player2")
	
	if not $nav_map.is_baking():
		$nav_map.bake_navigation_polygon()
	
	if player1.is_empty():	# If no enemies left
		get_tree().change_scene_to_file("res://scenes/player2win.tscn")
	if player2.is_empty():
		get_tree().change_scene_to_file("res://scenes/player1win.tscn")
