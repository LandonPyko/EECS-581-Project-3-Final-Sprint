extends StaticBody2D
var dead = false

func explosion():
	dead = true

func _process(_delta):
	if dead:
		free()
		return
