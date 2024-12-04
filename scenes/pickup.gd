extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Tank" or body.name == "enemy"):
		_apply_effect(body)
		queue_free()

func _apply_effect(body):
	body._super_shot()
	pass
