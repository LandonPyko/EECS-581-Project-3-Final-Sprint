extends CharacterBody2D

@export var speed          = 400
@export var rotation_speed = 3.5

@onready var BULLET = preload("res://bullet.tscn")

var rotation_direction = 0
var mouse_pos = Vector2(0,0) #set mouse pos to some place, don't matter.

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * Input.get_axis("down", "up") * speed
	
	#MAKE TURRENT TURN TOWARDS MOUSE
	$tankGun.global_rotation = mouse_pos.angle_to_point(position)-deg_to_rad(-90)
	

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	if Input.is_action_just_pressed("shoot"):
		mouse_pos = get_global_mouse_position()
		var bul = BULLET.instantiate()
		get_tree().root.add_child(bul)
		bul.global_rotation = ($tankGun.global_rotation)-deg_to_rad(-90)
		bul.global_position = $tankGun/fire_loc.global_position
	elif Input.is_action_just_pressed("mine"):
		mouse_pos = get_global_mouse_position()
		var mine = BULLET.instantiate()
		get_tree().root.add_child(mine)
		mine.type = "mine"
		mine.get_node("texture").texture = preload("res://assets/mine.png")
		mine.get_node("hitbox").shape = preload("res://mine_collision.tres")
		mine.global_position = global_position
		#velocity = target_position * speed
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		print("Mouse Motion at: ", event.position)
		mouse_pos = event.position
