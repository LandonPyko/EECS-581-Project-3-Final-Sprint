extends CharacterBody2D

@export var speed          = 550 #speed of bullet
@export var rotation_speed = 1.5 #not needed rn ##OPTION could do curving bullets?
@export var parent = preload("res://scenes/playerTank.tscn"); #create a dummy instance for the bullet to pretend with

var rotation_direction = 0 #not needed rn ##OPTION could do curving bullets?
var click_position 	   = Vector2() #not needed rn
var target_position	   = Vector2() #not needed rn
var dead := false #Check if timer has run out because can't do it when signalling.

func _physics_process(delta):
	##KILL the bullet if it needs to before doing opearations.
	if dead: #if life_time is out, free the instance and end the loop
		free()
		return
	
	##check for collision and do collision logic if one happend
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		velocity = velocity.bounce(collision.get_normal())
		global_rotation = velocity.angle()
		move_and_collide(reflect)
		
		# Implement Bullet Collison with other tanks here?
		
	else: #otherwise just do normal movement along rotation vector
		velocity = Vector2(1, 0).rotated(global_rotation) * speed
	
	#move_and_slide()



func _on_life_time_timeout(): #when life_time timer expires
	parent.dec_bullets()
	dead = true #Tell the bullet it's dead.
