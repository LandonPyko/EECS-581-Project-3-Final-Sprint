extends CharacterBody2D

@export var speed          := 400
@export var rotation_speed := 3.5
@export var max_bullets := 5 #OPTION Could make a changeable value for powerups
@export var max_mines := 2
@export var lives := 4
var my_color = Global.tank_Color
@export var score := 0

var bullet_size := Vector2(1,1)
var supershot := false
var tripleshot := false
@export_range(0, 360) var arc: float = 0
var cur_bullets := 0 #create var for cur mines and bullets
var cur_mines := 0   #walrus, := is used to make it only be of the type of its assignment
					 #in this case, an int. Just an optimization and helps prevent mishaps

@onready var BULLET = preload("res://scenes/bullet.tscn")#load the idea of a bullet to this var
												  #so we can make some from this script
@onready var MINE = preload("res://scenes/mine.tscn")

@onready var TREAD = preload("res://scenes/tankTread.tscn")

#$tankGun/fire_loc
@onready var fire_loc = $tankGun/CollisionShape2D/fire_loc

@onready var fire_check = $tankGun/CollisionShape2D
@onready var triple1 = $tankGun/CollisionShape2D/triple_1
@onready var triple2 = $tankGun/CollisionShape2D/triple_2

var rotation_direction = 0   #Just create it
var mouse_pos = Vector2(0,0) #set mouse pos to some place, don't matter.

#functions to decrease cur number of mines and bullets
func dec_mines():
	cur_mines = cur_mines - 1
func dec_bullets():
	cur_bullets = cur_bullets - 1
	if cur_bullets < 0:
		cur_bullets = 0

func _ready() -> void:
	_changecolor(my_color)

func check_fire() -> bool:
	#first you get the collider
	if tripleshot:
		if (fire_check.get_collision_count() > 0 or triple1.get_collision_count() > 0 or triple2.get_collision_count() >0):
			return false
	else:
		if fire_check.get_collision_count() > 0:
			return false
	return true

#func to get input from player
func get_input():	
	if self.is_in_group("Player"):
		rotation_direction = Input.get_axis("left", "right") #Direction to turn
		velocity = transform.x * Input.get_axis("down", "up") * speed #velocity to move at
		
	if self.is_in_group("Player1"):
		rotation_direction = Input.get_axis("leftKeyboard", "rightKeyboard") #Direction to turn
		velocity = transform.x * Input.get_axis("downKeyboard", "upKeyboard") * speed #velocity to move at
		
	if self.is_in_group("Player2"):
		rotation_direction = Input.get_axis("leftController", "rightController") #Direction to turn
		velocity = transform.x * Input.get_axis("downController", "upController") * speed #velocity to move at
	
	if self.is_in_group("Player") or self.is_in_group("Player1"):
		#MAKE TURRENT TURN TOWARDS MOUSE
		$tankGun.global_rotation = mouse_pos.angle_to_point(position)-deg_to_rad(-90)
		
	if self.is_in_group("Player") or self.is_in_group("Player2"):
		var deadzone = 0.5
		var controllerangle = Vector2.ZERO
		var xAxisRL = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var yAxisUD = Input.get_joy_axis(0 ,JOY_AXIS_RIGHT_Y)
		controllerangle = Vector2(xAxisRL, yAxisUD).angle()
		

		if abs(xAxisRL) > deadzone || abs(yAxisUD) > deadzone:
			controllerangle = Vector2(xAxisRL, yAxisUD).angle()
			$tankGun.global_rotation = controllerangle - deg_to_rad(90)
	

func _physics_process(delta):
	$debug_text.text = str(int($Super_Shot_Timer.time_left))
	##MOVEMENT
	get_input() # get details of movement
	
	rotation += rotation_direction * rotation_speed * delta #rotate tank
	move_and_slide() #move tank with physics, wooo
	_changecolor(my_color)
	
	var shootButton = "shoot"
	var mineButton  = "mine"
		
	if self.is_in_group("Player1"):
		shootButton = "shootMouse"
		mineButton  = "mineMouse"
		
	if self.is_in_group("Player2"):
		shootButton = "shootController"
		mineButton  = "mineController"
	
	##SHOOTING LOGIC
	if Input.is_action_just_pressed(shootButton) && (cur_bullets < max_bullets) and check_fire(): #check if want to and can fire
		$Player_Shoot.play()
		cur_bullets = cur_bullets + 1 #increase number of bullets fired
		if tripleshot:
			#do tripleshot things
			## this is the hard coded way to do it, could make it modular to add more bullets but
			## no support for that at this point
			var bul1 = BULLET.instantiate()
			var bul2 = BULLET.instantiate()
			var bul3 = BULLET.instantiate()
			bul1.parent = self
			bul2.parent = self
			bul3.parent = self
			bul1.scale = bullet_size
			bul2.scale = bullet_size
			bul3.scale = bullet_size
			get_tree().root.add_child(bul1)
			get_tree().root.add_child(bul2)
			get_tree().root.add_child(bul3)
			bul1.global_rotation = ($tankGun.global_rotation)-deg_to_rad(-90)
			bul2.global_rotation = ($tankGun.global_rotation)-deg_to_rad(-60)
			bul3.global_rotation = ($tankGun.global_rotation)-deg_to_rad(-120)
			bul1.global_position = fire_loc.global_position
			bul2.global_position = $tankGun/CollisionShape2D/triple_1/fire_loc.global_position
			bul3.global_position = $tankGun/CollisionShape2D/triple_2/fire_loc.global_position
		else:
			#create bullet instance for bullet
			var bul = BULLET.instantiate()
			bul.parent = self
			bul.scale = bullet_size
			get_tree().root.add_child(bul) #add to game tree at root #no reason not to for now
			bul.global_rotation = ($tankGun.global_rotation)-deg_to_rad(-90) #do orientation stuff because graphics
			#var direction = Vector2(cos($tankGun.global_rotation), sin($tankGun.global_rotation))
			bul.global_position = fire_loc.global_position
			# Needs to be fixed but idea is there
	elif Input.is_action_just_pressed(shootButton) && (cur_bullets < max_bullets) and !check_fire():
		$Failed_shot.play()
	elif Input.is_action_just_pressed(mineButton) && (cur_mines < max_mines):
		cur_mines = cur_mines + 1 #increase number of mines placed
		#create bullet instance for mine
		var mine = MINE.instantiate()
		mine.parent = self#get_parent().get_node("Tank") #set parent to this instance for refrence
		get_tree().root.add_child(mine) #add to game tree at root
		mine.add_to_group("Mines") # Add to group Mines for clean up at end of round
		mine.global_position = global_position #place at center of tank #TODO Change something with the rendering so tank is on top

	if Input.is_anything_pressed() == true:
		if $Timer.is_stopped():
			$Timer.start()
			$Timer.set_wait_time(.15)
	else:
		$Timer.stop()

func _changecolor(color):
	modulate = color
	#$tankBody.modulate = color
	#$tankGun.modulate = color

func _input(event): #get input event if one happens
	if event is InputEventMouseMotion: #if it is mouse movement
		#print("Mouse Motion at: ", event.position) #print debug info
		mouse_pos = event.global_position #change mouse_pos to new pos
		

func _super_shot():
	#take the given colliion shape and move it by 106
	$tankGun/CollisionShape2D.position = Vector2(0,106)
	$tankGun/CollisionShape2D.scale = Vector2(1,1)
	bullet_size = Vector2(2,2)
	supershot = true
	$Super_Shot_Timer.start()
	
#func _super_not(): # Reset bullet size and supershot flag
	#bullet_size = Vector2(1, 1)
	#supershot = false

func _on_timer_timeout() -> void:
	var tread = TREAD.instantiate()
	tread.global_position = global_position
	tread.rotation = rotation - deg_to_rad(90)
	get_parent().add_child(tread)
	#if (supershot == true): # Check on timer stop since multiple timers seem to share this function?
		#_super_not() # If timer stoppped, reset supershot variables


func _on_super_shot_timer_timeout():
	$tankGun/CollisionShape2D.position = Vector2(0,84)
	$tankGun/CollisionShape2D.scale = Vector2(0.5,0.5)
	bullet_size = Vector2(1,1)
	supershot = false

func _speedup():
	speed = speed*1.5
	$speedup_timer.start(10)

func _on_speedup_timer_timeout():
	speed = 400

func _triple():
	tripleshot = true
	$triple_timer.start(10)

func _on_triple_timer_timeout():
	tripleshot = false
