extends CharacterBody2D

@export var speed          = 400 #speed of bullet
@export var parent = preload("res://playerTank.tscn"); #create a dummy instance for the bullet to pretend with

var rotation_direction = 0 #not needed rn ##OPTION could do curving bullets?
var click_position 	   = Vector2() #not needed rn
var target_position	   = Vector2() #not needed rn
var dead := false #Check if timer has run out because can't do it when signalling.


func _physics_process(_delta):
	if dead: #if life_time is out, free the instance
		free()


func _on_life_time_timeout(): #when life_time timer expires
	#Clear either a bullet or mine
	parent.dec_mines()
	dead = true #Tell the mine it's dead.
