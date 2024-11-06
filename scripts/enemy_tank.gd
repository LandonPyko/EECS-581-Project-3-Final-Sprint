extends CharacterBody2D

#can probably make descriptor arrays to define behavior of different enemies.

@export var score_given := 1

@onready var BULLET = preload("res://scenes/bullet.tscn")#load the idea of a bullet to this var
												  #so we can make some from this script
@onready var MINE = preload("res://scenes/mine.tscn")

@onready var nav_agent : NavigationAgent2D = $nav_agent

enum DIFFICULTIES {EASY, MEDIUM, HARD}# Will retrieve the type from the menu button, then act accordingly
var difficulty = "Easy" # For now we'll just set it to easy
#var target_dest = Vector2.ZERO
# We can change this to set it to whatever the player chooses it as
# Then we can have different movement logic based on that

var speed = 150  # Set your speed constant
var target_pos : Vector2 = Vector2.ZERO

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	nav_agent.target_position = target_pos

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		_random_move()
	var current_position: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	global_rotation = rotate_toward(global_rotation, global_position.direction_to(next_path_position).angle(), 3 * delta)
	$dummy.global_position = target_pos
	print(rotation)
	print(get_angle_to(target_pos))
	
	velocity = current_position.direction_to(next_path_position) * speed
	move_and_slide()
	# Keeps moving along the vector until timer runout

func _random_move():
	target_pos.x = randi_range(48, 1752)
	target_pos.y = randi_range(48, 892)
	nav_agent.target_position = target_pos
	#velocity.x = randf_range(-1, 1)
	#velocity.y = randf_range(-1, 1)
	#velocity = velocity.normalized() * speed # Normalize and set the speed


func _on_move_timer_timeout() -> void:
	_random_move()  # Call random_move to set a new velocity
