extends CharacterBody2D

@export var speed          = 550 #speed of bullet
@export var rotation_speed = 1.5 #not needed rn ##OPTION could do curving bullets?
@export var parent = preload("res://scenes/playerTank.tscn"); #create a dummy instance for the bullet to pretend with

var my_color : Color = Global.bullet_Color

var rotation_direction = 0 #not needed rn ##OPTION could do curving bullets?
var click_position 	   = Vector2() #not needed rn
var target_position	   = Vector2() #not needed rn
var dead := false #Check if timer has run out because can't do it when signalling.

func _ready():
	_changecolor(my_color)

func _physics_process(delta):
	##KILL the bullet if it needs to before doing opearations.
	if dead: #if life_time is out, free the instance and end the loop
		free()
		return
	
	##check for collision and do collision logic if one happend
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("Enemy") and collision_layer == 2:
			$hitTank.play()
			print("Hit a tank!")
			Global.temp_score += 1 # Increment score
			# print(Global.temp_score)
			collider.free()
			free()	# If it hits a tank we free the bullet instance
		elif collider.is_in_group("Player"):	
			$hitTank.play()
			print("hello")
			collider.free()
			free()
		elif collider.is_in_group("Player1"):
			$hitTank.play()
			print("Player 1 killed")
			Global.p2_score += 1
			collider.free()
		elif collider.is_in_group("Player2"):
			$hitTank.play()
			print("Player 2 killed")
			Global.p1_score += 1
			collider.free()
		else:
			var reflect = collision.get_remainder().bounce(collision.get_normal())
			velocity = velocity.bounce(collision.get_normal())
			global_rotation = velocity.angle()
			move_and_collide(reflect)
		
		# Implement Bullet Collison with other tanks here?
		
	else: #otherwise just do normal movement along rotation vector
		velocity = Vector2(1, 0).rotated(global_rotation) * speed
	

func _changecolor(color):
	modulate = color

func _on_life_time_timeout(): #when life_time timer expires
	if parent != null:
		parent.dec_bullets()
	dead = true #Tell the bullet it's dead.

func bullet():#dummy func to determine if bullet
	pass
