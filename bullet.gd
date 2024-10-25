extends CharacterBody2D

@export var speed          = 400 #speed of bullet
@export var rotation_speed = 1.5 #not needed rn ##OPTION could do curving bullets?
@export var type = "bullet";     #assign type of bullet, assume normal ##TODO get rid of when mine scene is created
@export var parent = preload("res://playerTank.tscn"); #create a dummy instance for the bullet to pretend with

var rotation_direction = 0 #not needed rn ##OPTION could do curving bullets?
var click_position 	   = Vector2() #not needed rn
var target_position	   = Vector2() #not needed rn
var dead := false #Check if timer has run out because can't do it when signalling.


func _physics_process(delta):
	if type == "bullet": #if normal bullet, do movement logic at  consistient speed and direction.
						 ##TODO figure out richochet logic
		velocity = Vector2(1, 0).rotated(rotation) * speed
		move_and_slide()
	if dead: #if life_time is out, free the instance
		free()


func _on_life_time_timeout(): #when life_time timer expires
	#Clear either a bullet or mine ##TODO make it only bullet when mine scene is made
	if type == "bullet":
		parent.dec_bullets()
	elif type == "mine":
		parent.dec_mines()
	dead = true #Tell the bullet it's dead.
