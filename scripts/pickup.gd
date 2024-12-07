extends Node2D

@export var effect          := "dummy"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") or body.is_in_group("Player1") or body.is_in_group("Player2") or """body.is_in_group("Enemy")"""): # disabled enemy collision for now unless we want to add it
		_apply_effect(body)
		queue_free()

func _apply_effect(body):
	if effect == "dummy":
		var types = ["super", "speed", "triple"]
		var rng = RandomNumberGenerator.new()
		effect = types[rng.randi_range(0, 2)]
	if effect == "super":
		body._super_shot()
	elif effect	 == "speed":
		body._speedup()
	elif effect == "triple":
		body._triple()
	pass
