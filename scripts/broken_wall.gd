extends StaticBody2D
var dead = false

func explosion():
	$Break.play()
	dead = true

func _process(_delta):
	if dead:
		var temp = get_parent().get_parent()
		free()
		temp.bake_navigation_polygon()
		return
