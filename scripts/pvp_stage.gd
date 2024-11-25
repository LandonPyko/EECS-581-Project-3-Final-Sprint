extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player1 = get_tree().get_nodes_in_group("Player1")
	var player2 = get_tree().get_nodes_in_group("Player2")
	
	if not $nav_map.is_baking():
		$nav_map.bake_navigation_polygon()
		
	if Global.p1_score + Global.p2_score < 10:
		if player1.is_empty():	# If no enemies left
			Global.winner = 2
			get_tree().change_scene_to_file("res://scenes/player2win.tscn")
		if player2.is_empty():
			Global.winner = 1
			get_tree().change_scene_to_file("res://scenes/player1win.tscn")
	
	else:
		if Global.p1_score > Global.p2_score:
			get_tree().change_scene_to_file("res://scenes/game_over_player1win.tscn")
		elif Global.p2_score > Global.p1_score:
			get_tree().change_scene_to_file("res://scenes/game_over_player2win.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/game_over_tie.tscn")
