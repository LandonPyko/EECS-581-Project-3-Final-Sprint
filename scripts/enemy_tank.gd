extends CharacterBody2D

#can probably make descriptor arrays to define behavior of different enemies.

@export var score_given := 1

@onready var BULLET = preload("res://scenes/bullet.tscn")#load the idea of a bullet to this var
												  #so we can make some from this script
@onready var MINE = preload("res://scenes/mine.tscn")

@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var move_timer : Timer = $MoveTimer
@onready var shot_timer : Timer = $shot_timer


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
		move_timer.start()
	var _current_position: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	rotation = rotate_toward(rotation, global_position.direction_to(next_path_position).angle(), 4 * delta)

	velocity = transform.x * Vector2(1,1) * speed

	move_and_slide()
	# Keeps moving along the vector until timer runout

func _random_move():
	target_pos.x = randi_range(0, 1800)
	target_pos.y = randi_range(0, 940)
	nav_agent.target_position = target_pos
	
func move_turret():
	$tankGun.global_rotation = randf_range(0,2*PI)

func shoot():
	#create bullet instance for bullet
	
	var bul := BULLET.instantiate()
	bul.parent = self #set parent to this instance for refrence
	get_tree().root.add_child(bul) #add to game tree at root #no reason not to for now
	bul.set_collision_layer(8)
	bul.global_rotation = ($tankGun.global_rotation)-deg_to_rad(-90) #do orientation bullshit because graphics are fucked fuck you andrew jk love you
	bul.global_position = $tankGun/fire_loc.global_position #move to the fire loc so it pretend to fire from turret
	#Should change a bit so end of bullet is end of turret but meh, like a 5 minute fix I'll leave to someone else
	move_turret()

func _on_move_timer_timeout() -> void:
	_random_move()  # Call random_move to set a new velocity

func dec_bullets():
	pass #dummy function because I don't want to do logic

func _on_shot_timer_timeout():
	shoot()
	shot_timer.start(randf_range(0.5,2))
