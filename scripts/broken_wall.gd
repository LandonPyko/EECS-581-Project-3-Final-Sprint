extends StaticBody2D
var dead = false
var played = false

func explosion():
	if !played:
		$Break.play()
		played = true
	dead = true

func _process(_delta):
	if dead and !$Break.playing:
		var temp = get_parent().get_parent()
		free()
		
		if !temp.is_baking():
			temp.bake_navigation_polygon()
		return
