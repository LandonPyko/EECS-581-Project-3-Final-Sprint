extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var player = get_tree().get_nodes_in_group("Player")
	#var bullets = get_tree().get_nodes_in_group("Bullets")
	#var mines = get_tree().get_nodes_in_group("Mines")
	
	#just get everyhing that exists right now
	var nodes = get_tree().root.get_children()
	
	
	if not $nav_map.is_baking():
		$nav_map.bake_navigation_polygon()
	
	if enemies.is_empty() and player.is_empty():
		for node in nodes:
			if node.is_in_group("Bullets") or node.is_in_group("Mines"):
				node.free()
		#bullets.clear()
		#mines.clear()
		get_tree().change_scene_to_file("res://scenes/roundloss.tscn")
	elif enemies.is_empty():	# If no enemies left
		for node in nodes:
			if node.is_in_group("Bullets") or node.is_in_group("Mines"):
				node.free()
		#for nodes in bullets:
			#remove_child(nodes)
		#for nodes in mines:
			#remove_child(nodes)
		get_tree().change_scene_to_file("res://scenes/roundwin.tscn")
	elif player.is_empty():
		for node in nodes:
			if node.is_in_group("Bullets") or node.is_in_group("Mines"):
				node.free()
		#bullets.clear()
		#mines.clear()
		get_tree().change_scene_to_file("res://scenes/roundloss.tscn")
