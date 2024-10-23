extends CharacterBody2D

@export var speed          = 400
@export var rotation_speed = 1.5

var rotation_direction = 0
var click_position 	   = Vector2()
var target_position	   = Vector2()


func get_input():
	rotation_direction = Input.get_axis("left", "right")	
	#velocity = transform.x * Input.get_axis("down", "up") * speed
	#MAKE TURRENT TURN TOWARDS MOUSE
	var target = get_viewport().get_mouse_position()
	$bulletShot.rotation  = target.angle_to_point(position)-deg_to_rad(180)
	

func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		click_position = get_global_mouse_position()
		target_position = (click_position - position).normalized()
		velocity = target_position * speed
		move_and_slide()
		
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
