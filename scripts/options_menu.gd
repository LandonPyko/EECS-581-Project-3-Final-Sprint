extends Control

@onready var colorPick = $customization/HBoxContainer/TankColorPick
@onready var bulColorPick = $customization/HBoxContainer2/bulletColorPick


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colorPick.color = Global.tank_Color



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	
func _on_color_picker_button_popup_closed() -> void:
	Global.tank_Color = colorPick.color
	print(Global.tank_Color)


func _on_bullet_color_pick_popup_closed():
	Global.bullet_Color = bulColorPick.color
	print(Global.bullet_Color)
