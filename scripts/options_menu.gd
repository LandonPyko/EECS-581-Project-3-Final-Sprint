extends Control

@onready var tank1colorPick := $customization/HBoxContainer/Tank1ColorPick
@onready var bul1ColorPick := $customization/HBoxContainer2/bullet1ColorPick
@onready var tank2colorPick := $customization/HBoxContainer3/Tank2ColorPick
@onready var bul2ColorPick := $customization/HBoxContainer4/bullet2ColorPick


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music()
	var tank1PickTmp = tank1colorPick.get_picker()
	var tank2PickTmp = tank2colorPick.get_picker()
	var bul1ColorPickTmp = bul1ColorPick.get_picker()
	var bul2ColorPickTmp = bul2ColorPick.get_picker()
	
	tank1PickTmp.color_modes_visible = false
	tank1PickTmp.presets_visible = false
	tank1PickTmp.sliders_visible = false
	tank1PickTmp.hex_visible = false
	
	tank2PickTmp.color_modes_visible = false
	tank2PickTmp.presets_visible = false
	tank2PickTmp.sliders_visible = false
	tank2PickTmp.hex_visible = false
	
	bul1ColorPickTmp.color_modes_visible = false
	bul1ColorPickTmp.presets_visible = false
	bul1ColorPickTmp.sliders_visible = false
	bul1ColorPickTmp.hex_visible = false
	
	bul2ColorPickTmp.color_modes_visible = false
	bul2ColorPickTmp.presets_visible = false
	bul2ColorPickTmp.sliders_visible = false
	bul2ColorPickTmp.hex_visible = false

	tank1colorPick.color = Global.tank1_Color
	tank2colorPick.color = Global.tank2_Color
	bul1ColorPick.color = Global.bullet1_Color
	bul2ColorPick.color = Global.bullet2_Color
	$audio/HBoxContainer/Master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$audio/HBoxContainer2/FX_slider.value	 = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("FX")))
	$audio/HBoxContainer3/Music_slider.value	 = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$Button.grab_focus()

func _on_master_slider_value_changed(value: float) -> void:
	Global.set_bus_volume(AudioServer.get_bus_index("Master"), value)
	#print(db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))) # debug stuff
	#print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	
func _on_fx_slider_value_changed(value: float) -> void:
	Global.set_bus_volume(AudioServer.get_bus_index("FX"), value)

func _on_music_slider_value_changed(value: float) -> void:
	Global.set_bus_volume(AudioServer.get_bus_index("Music"), value)

func _on_button_pressed() -> void: # Return button
	var next_screen = "res://scenes/main_menu.tscn"
	if Global.optionsReturnScreen != null:
		next_screen = Global.optionsReturnScreen
		Global.optionsReturnScreen = null
	
	#if Global.current_level > 0:
	#	if Global.difficulty == "pvp":
	#		next_screen = "res://scenes/level%d_pvp.tscn" % Global.current_level
	#	else:
	#		next_screen = "res://scenes/level%d.tscn" % Global.current_level
	#	
	get_tree().change_scene_to_file(next_screen)
	
	
func _on_color_picker_button_popup_closed() -> void:
	Global.tank1_Color = tank1colorPick.color
	print(Global.tank1_Color)


func _on_bullet_color_pick_popup_closed():
	Global.bullet1_Color = bul1ColorPick.color
	print(Global.bullet1_Color)


func _on_tank_2_color_pick_popup_closed() -> void:
	Global.tank2_Color = tank2colorPick.color
	print(Global.tank2_Color)


func _on_bullet_2_color_pick_popup_closed() -> void:
	Global.bullet2_Color = bul2ColorPick.color
	print(Global.bullet1_Color)
