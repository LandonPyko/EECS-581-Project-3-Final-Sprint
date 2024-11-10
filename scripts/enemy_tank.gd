extends CharacterBody2D

#can probably make descriptor arrays to define behavior of different enemies.

@export var score_given := 1

@onready var BULLET = preload("res://scenes/bullet.tscn")#load the idea of a bullet to this var
												  #so we can make some from this script
@onready var MINE = preload("res://scenes/mine.tscn")

@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var tankGun : Sprite2D = $tankGun
@onready var fire_loc : Node2D = $tankGun/fire_loc
@onready var move_timer : Timer = $MoveTimer
@onready var shot_timer : Timer = $shot_timer
@onready var vision : ShapeCast2D = $vision

var tur_dir := 0.0
enum DIFFICULTIES {EASY, MEDIUM, HARD}# Will retrieve the type from the menu button, then act accordingly
var difficulty = "hard" # For now we'll just set it to easy
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
	if nav_agent.is_navigation_finished() and difficulty != "hard":
		_random_move()
		move_timer.start()
	else:
		hard_move()
		move_timer.start()
	var _current_position: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	rotation = rotate_toward(rotation, global_position.direction_to(next_path_position).angle(), 4 * delta)
	velocity = transform.x * Vector2(1,1) * speed
	move_turret(delta)
	move_and_slide()
	# Keeps moving along the vector until timer runout

func _random_move():
	target_pos.x = randi_range(0, 1800)
	target_pos.y = randi_range(0, 940)
	nav_agent.target_position = target_pos
	
func hard_move():
	#okay so first we need to path towards player. but not all the way
	#I'd like to make a circle around the player that the tank tries to pathfind onto
	#First we get position of player I guess
	#Need to check for player, collider things
		##TODO probably make the collider logic its own function that returns the player collider or null
	if vision.is_colliding():
		for i in range(0, vision.get_collision_count()): #get colliders
			var collider = vision.get_collider(i) #call collider
			if collider != null: #if its a thing
				if collider.collision_layer == 1:#players are on layer 1. Maybe decide a better way to check this
					var temp_pos = collider.global_position #this is where the player is
					target_pos = temp_pos - Vector2(1,0).rotated((temp_pos - global_position).angle()) * 150
					nav_agent.target_position = target_pos
					$dummy.global_position = target_pos
	else:
		_random_move()
	
	
	
func move_turret(delta):
	if vision.is_colliding() and difficulty == "medium":
		for i in range(0, vision.get_collision_count()):
			var collider = vision.get_collider(i)
			if collider != null:
				var test : CharacterBody2D = CharacterBody2D.new()
				test.collision_layer
				if collider.collision_layer == 1:
					var target = global_position.direction_to(collider.global_position).angle()-deg_to_rad(90)
					tankGun.global_rotation = rotate_toward(tankGun.global_rotation, target, 2 * delta)
	elif vision.is_colliding() and difficulty == "hard":
		for i in range(0, vision.get_collision_count()):
			var collider = vision.get_collider(i)
			if collider != null:
				var test : CharacterBody2D = CharacterBody2D.new()
				test.collision_layer
				if collider.collision_layer == 1: # is a player
					#first we get position of player
					var player_pos = collider.global_position
					#then velocity?
					var player_velocity = collider.velocity
					#then distance to player
					var square = pow((player_pos.x - fire_loc.global_position.x), 2)
					var distance = sqrt(pow((player_pos.x - fire_loc.global_position.x), 2)+pow((player_pos.y - fire_loc.global_position.y), 2))
					#given those, add velocity times delta to the postion? maybe distance to player to consider timing?
					
					var predicted_pos = player_pos + (player_velocity*(delta*9)) 
					print("Distance to is: ", distance)
					var target_rotation = global_position.direction_to(predicted_pos).angle()-deg_to_rad(90)
					tankGun.global_rotation = rotate_toward(tankGun.global_rotation, target_rotation, 10 * delta)
	else:
		tankGun.global_rotation = rotate_toward(tankGun.global_rotation, tur_dir, 1 * delta)


func shoot():
	#create bullet instance for bullet
	tur_dir = randf_range(0,deg_to_rad(360))
	var bul := BULLET.instantiate()
	bul.parent = self #set parent to this instance for refrence
	get_tree().root.add_child(bul) #add to game tree at root #no reason not to for now
	bul.set_collision_layer(8)
	bul._changecolor(Color.DARK_SLATE_BLUE)
	bul.global_rotation = ($tankGun.global_rotation)-deg_to_rad(-90) #do orientation bullshit because graphics are fucked fuck you andrew jk love you
	bul.global_position = $tankGun/fire_loc.global_position #move to the fire loc so it pretend to fire from turret
	#Should change a bit so end of bullet is end of turret but meh, like a 5 minute fix I'll leave to someone else

func _on_move_timer_timeout() -> void:
	_random_move()  # Call random_move to set a new velocity

func dec_bullets():
	pass #dummy function because I don't want to do logic

func _on_shot_timer_timeout():
	shoot()
	shot_timer.start(randf_range(0.5,2))
