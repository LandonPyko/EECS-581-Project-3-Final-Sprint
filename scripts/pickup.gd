extends Node2D

@export var effect          := "dummy"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if effect == "dummy":
		var types = ["super", "speed", "triple"]
		var rng = RandomNumberGenerator.new()
		var effect = types[rng.randf_range(0, 2)]
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Tank" or body.name == "enemy"):
		_apply_effect(body)
		queue_free()

func _apply_effect(body):
	if effect == "super":
		body._super_shot()
	elif effect	 == "speed":
		body._speedup()
	elif effect == "triple":
		body._triple()
	pass
