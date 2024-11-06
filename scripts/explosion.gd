extends Sprite2D

@onready var area = $collider
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		free()
		return
	if area.is_colliding():
		print("Colliding with explosion")
		for i in range(0, area.get_collision_count()):
			var collider = area.get_collider(i)
			if collider != null:
				if collider.has_method("explosion"):
					collider.explosion()
					print("exploded thing")
				print("dummy space")


func _on_lifetime_timeout():
	dead = true
