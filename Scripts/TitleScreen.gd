extends Node2D

enum menuState {TITLE, SETTINGS, CREDITS}

var CURRENT_STATE = menuState.TITLE

func _ready():
	updateUI()

func updateUI():
	if CURRENT_STATE == menuState.TITLE:
		$CanvasLayer/TITLE/Play.grab_focus()
		$CanvasLayer/TITLE.visible = true
		$CanvasLayer/SETTINGS.visible = false
		$CanvasLayer/CREDITS.visible = false
	elif CURRENT_STATE == menuState.SETTINGS:
		$CanvasLayer/SETTINGS/Back.grab_focus()
		$CanvasLayer/TITLE.visible = false
		$CanvasLayer/SETTINGS.visible = true
		$CanvasLayer/CREDITS.visible = false
	elif CURRENT_STATE == menuState.CREDITS:
		$CanvasLayer/CREDITS/Back.grab_focus()
		$CanvasLayer/TITLE.visible = false
		$CanvasLayer/SETTINGS.visible = false
		$CanvasLayer/CREDITS.visible = true

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Levels/LEVEL/LevelTuto.tscn")

func _on_settings_pressed():
	CURRENT_STATE = menuState.SETTINGS
	updateUI()

func _on_credits_pressed():
	CURRENT_STATE = menuState.CREDITS
	updateUI()

func _on_quit_pressed():
	get_tree().quit()	

func _on_back_pressed():
	CURRENT_STATE = menuState.TITLE
	updateUI()

func _on_volume_slider_value_changed(value):
	MusicAndAmbiance.change_volume(value)
