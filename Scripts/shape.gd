extends Node2D
class_name Shape

var SHAPE = ShapeType.CIRCLE
var ENTERED = false

func _process(delta):
	if ENTERED and !Global.PLAYING_BODY:
		if Input.is_action_just_pressed("interaction"):
			Global.CURRENT_SHAPE = SHAPE

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("soul"):
		ENTERED = true


func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group("soul"):
		ENTERED = false

