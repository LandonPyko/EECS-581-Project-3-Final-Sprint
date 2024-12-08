extends CharacterBody2D

@export var parent = preload("res://scenes/playerTank.tscn"); #create a dummy instance for the bullet to pretend with
@export var explosion_radius = 10 # create a var to say how big explosion is
@export var explodeTimer = 5 #create a var to say how long until explostion

var rotation_direction = 0 #not needed rn ##OPTION could do curving bullets?
var click_position 	   = Vector2() #not needed rn
var target_position	   = Vector2() #not needed rn
var dead := false #Check if timer has run out because can't do it when signalling.

func _ready():
	$life_time.wait_time = explodeTimer
	$Placing.play()

func _physics_process(_delta):
	if dead: #if life_time is out, free the instance
		queue_free()

func _on_life_time_timeout(): #when life_time timer expires
	explode()

func explode():
	dead = true
	if parent != null:
		parent.dec_mines()
	var explosion = preload("res://scenes/explosion.tscn").instantiate()
	explosion.global_position = global_position
	get_tree().root.add_child(explosion)
	pass #some logic creating a sprite animation and collison box of some size


func _on_arming_timeout():
	$hitbox.disabled = false


func mine(): #dummy function to detect mines. Cant think of a better way rn
	pass
