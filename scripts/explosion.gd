extends Sprite2D

@onready var area = $collider
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Explosion.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dead:
		free()
		return
	if area.is_colliding():
		print("Colliding with explosion")
		for i in range(0, area.get_collision_count()):
			var collider = area.get_collider(i)
			if collider != null:
				if collider.is_in_group("Enemy"):
					$HitTank.play()
					print("Hit a tank!")
					Global.temp_score += 1 # Increment score
					collider.free()
				elif collider.is_in_group("Player"):	
					$HitTank.play()
					print("hello")
					collider.free()
				elif collider.is_in_group("Player1"):
					$HitTank.play()
					print("Player 1 killed")
					Global.p2_score += 1
					collider.free()
				elif collider.is_in_group("Player2"):
					$HitTank.play()
					print("Player 2 killed")
					Global.p1_score += 1
					collider.free()
				elif collider.has_method("explosion"):
					collider.explosion()
					print("exploded thing")
				print("dummy space")


func _on_lifetime_timeout():
	dead = true
