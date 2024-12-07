extends Node2D

var timer = Timer.new()
var start_timer = false

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
func _process(delta: float) -> void:
	var player1 = get_tree().get_nodes_in_group("Player1")
	var player2 = get_tree().get_nodes_in_group("Player2")
	
	
	if not $nav_map.is_baking():
		$nav_map.bake_navigation_polygon()
		
	if Global.p1_score + Global.p2_score < 10:
		if player1.is_empty() and player2.is_empty():
			if stage_clear():
				get_tree().change_scene_to_file("res://scenes/tie_round.tscn")
		elif player1.is_empty():	# If no enemies left
			if stage_clear():
				Global.winner = 2
				get_tree().change_scene_to_file("res://scenes/player2win.tscn")
		elif player2.is_empty():
			if stage_clear():
				Global.winner = 1
				get_tree().change_scene_to_file("res://scenes/player1win.tscn")
	
	else:
		if Global.p1_score > Global.p2_score:
			get_tree().change_scene_to_file("res://scenes/game_over_player1win.tscn")
		elif Global.p2_score > Global.p1_score:
			get_tree().change_scene_to_file("res://scenes/game_over_player2win.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/game_over_tie.tscn")
