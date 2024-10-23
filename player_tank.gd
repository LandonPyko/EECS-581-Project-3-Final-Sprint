extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5

var rotation_direction = 0


func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * Input.get_axis("down", "up") * speed
	
	#MAKE TURRENT TURN TOWARDS MOUSE
	var target = get_viewport().get_mouse_position()
	$tankGun.rotation = target.angle_to_point(position)-deg_to_rad(-90)

func _physics_process(delta):
	
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
