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

var my_color : Color = Color.RED

var type = "pink" #define type of enemy tank
#add support for yellow,pink, and oragne
##Yellow needs to place mines instead of bullets
##pink needs to reduce shot_timer and not add randomness
##orange needs to place mines and shoot bullets

const MINE_SAFE_DIST = 400 #change how far to run from mines
const BUL_SAFE_DIST = 75 #change how far to run from bullets
var tur_dir := 0.0
enum DIFFICULTIES {EASY, MEDIUM, HARD}# Will retrieve the type from the menu button, then act accordingly
var difficulty = "hard" # For now we'll just set it to easy

var dangers= []
#var target_dest = Vector2.ZERO
# We can change this to set it to whatever the player chooses it as
# Then we can have different movement logic based on that


var speed = 150  # Set your speed constant
var target_pos : Vector2 = Vector2(900,400)

func _ready():
	change_type(type)
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
	
	rotation = rotate_toward(rotation, global_position.direction_to(next_path_position).angle(), 10 * delta)
	velocity = transform.x * Vector2(1,1) * speed
	move_turret(delta)
	move_and_slide()
	# Keeps moving along the vector until timer runout

func _random_move():
	target_pos.x = randi_range(0, 1800)
	target_pos.y = randi_range(0, 940)
	nav_agent.target_position = target_pos
	
func hard_move():
		##TODO probably make the collider logic its own function that returns the player collider or null
	vision.force_shapecast_update()
	if vision.is_colliding():
		for i in range(0, vision.get_collision_count()): #get colliders
			var collider = vision.get_collider(i) #call collider
			if collider != null: #if its a thing
				if collider.collision_layer == 2: #its a bullet or a mine
					if collider.has_method("mine"): #this detects minesw
						var temp_pos = collider.global_position #this is where the mine is
						var distance = global_position.distance_to(temp_pos)
						var other_distance = target_pos.distance_to(temp_pos)
						var pass_check = true
						for j in range(dangers.size()):
							if dangers[j][0] == collider:
								pass_check = false
						if pass_check:
							dangers.append([collider,distance,"mine"])
						if distance < MINE_SAFE_DIST or other_distance < MINE_SAFE_DIST: #if too close
							target_pos = temp_pos - Vector2(1,0).rotated((temp_pos - global_position).angle()) * MINE_SAFE_DIST
							nav_agent.target_position = target_pos
							$dummy.global_position = target_pos
							return
					elif collider.has_method("bullet"):
						var bul_pos = collider.global_position #this is where the bullet is
						#point in the direction of the bullet
						var bul_future = bul_pos + collider.velocity
						var point = Geometry2D.get_closest_point_to_segment_uncapped(global_position, bul_pos, bul_future)
						
						var distance = global_position.distance_to(point)
						var other_distance = target_pos.distance_to(point)
						var pass_check = true
						for j in range(dangers.size()):
							if dangers[j][0] == collider:
								pass_check = false
						if pass_check:
							dangers.append([collider,distance,"bullet"])
						if distance < BUL_SAFE_DIST or other_distance < BUL_SAFE_DIST: #if too close
							target_pos = point - Vector2(1,0).rotated((point - global_position).angle()) * BUL_SAFE_DIST
							nav_agent.target_position = target_pos
							$dummy.global_position = target_pos
							return
						
				if collider.collision_layer == 1:#players are on layer 1. Maybe decide a better way to check this
					var temp_pos = collider.global_position #this is where the player is
					target_pos = temp_pos - Vector2(1,0).rotated((temp_pos - global_position).angle()) * 150
					update_dangers()
					for danger in dangers:
						if danger[2] == "mine" and danger[1] < MINE_SAFE_DIST:
							target_pos = danger[0].global_position - Vector2(1,0).rotated((danger[0].global_position - global_position).angle()) * MINE_SAFE_DIST
						elif danger[2] == "bullet" and danger[1] < BUL_SAFE_DIST:
							update_dangers()
							var bul_future = danger[0].global_position + danger[0].velocity
							var point = Geometry2D.get_closest_point_to_segment_uncapped(global_position, danger[0].global_position, bul_future)
							target_pos = point - Vector2(1,0).rotated((point - global_position).angle()) * BUL_SAFE_DIST
					nav_agent.target_position = target_pos
					$dummy.global_position = target_pos

func update_dangers():
	for i in range(dangers.size()):
		if i > dangers.size()-1:
			return
		if dangers[i][0] == null:
			dangers.remove_at(i)
		else:
			dangers[i][1] = global_position.distance_to(dangers[i][0].global_position)
	
	
	
func move_turret(delta):
	vision.force_shapecast_update()
	if vision.is_colliding() and difficulty == "medium":
		for i in range(0, vision.get_collision_count()):
			var collider = vision.get_collider(i)
			if collider != null:
				if collider.collision_layer == 1:
					var target = global_position.direction_to(collider.global_position).angle()-deg_to_rad(90)
					tankGun.global_rotation = rotate_toward(tankGun.global_rotation, target, 2 * delta)
	elif vision.is_colliding() and difficulty == "hard":
		for i in range(0, vision.get_collision_count()):
			var collider = vision.get_collider(i)
			if collider != null:
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
					#print("Distance to is: ", distance)
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

func mine():
	var mine = MINE.instantiate()
	mine.parent = self #set parent to this instance for refrence
	get_tree().root.add_child(mine) #add to game tree at root
	mine.set_collision_layer(8)
	mine.global_position = global_position #place at center of tank #TODO Change something with the rendering so tank is on top

func _on_move_timer_timeout() -> void:
	_random_move()  # Call random_move to set a new velocity

func dec_bullets():
	pass #dummy function because I don't want to do logic

func dec_mines():
	pass

func change_color(color: Color):
	modulate = color
	
func change_type(newType: String):
	type = newType
	if type == "red":
		change_color(Color.RED)
	elif type == "orange":
		change_color(Color.ORANGE)
	elif type == "pink":
		change_color(Color.PINK)
	elif type == "yellow":
		change_color(Color.YELLOW)
	

func _on_shot_timer_timeout():
	if type != "yellow":
		shoot()
	if type == "pink":
		shot_timer.start(0.5)
	else:
		shot_timer.start(randf_range(0.5,2))


func _on_mine_timer_timeout():
	if type == "yellow" or type == "orange":
		mine()
