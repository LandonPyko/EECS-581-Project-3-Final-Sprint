extends CharacterBody2D

#can probably make descriptor arrays to define behavior of different enemies.

@export var score_given := 1

@onready var BULLET = preload("res://scenes/bullet.tscn")#load the idea of a bullet to this var
												  #so we can make some from this script
@onready var MINE = preload("res://scenes/mine.tscn")

enum DIFFICULTIES {EASY, MEDIUM, HARD}# Will retrieve the type from the menu button, then act accordingly
var difficulty = "Easy" # For now we'll just set it to easy
# We can change this to set it to whatever the player chooses it as
# Then we can have different movement logic based on that

const SPEED = 150  # Set your speed constant

#func _ready():
	#$MoveTimer.wait_time = 2
	#$MoveTimer.connect("timeout", Callable(self, "_on_MoveTimer_timeout"))  # Connect the timer's timeout signal
	#$MoveTimer.start()

func _physics_process(_delta):
	move_and_slide() # Called every frame
	# Keeps moving along the vector until timer runout

func _random_move():
	velocity.x = randf_range(-1, 1)
	velocity.y = randf_range(-1, 1)
	velocity = velocity.normalized() * SPEED # Normalize and set the speed


func _on_move_timer_timeout() -> void:
	_random_move()  # Call random_move to set a new velocity
