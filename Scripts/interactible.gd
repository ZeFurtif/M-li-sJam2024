extends Node2D
class_name Interactible

var SHAPE_HOLE = ShapeType.CIRCLE
var ACTIVE = false
var ENTERED = false
var LAST_ACTIVATION_TIME = 0

func _process(delta):
	if ENTERED and !Global.PLAYING_BODY:
		if Input.is_action_just_pressed("interaction") and Global.CURRENT_SHAPE == SHAPE_HOLE:
			activate()
			LAST_ACTIVATION_TIME = Time.get_ticks_msec()
	if (Time.get_ticks_msec() - LAST_ACTIVATION_TIME) >= 5000 and ACTIVE:
		deactivate()

func activate():
	ACTIVE = true
	Global.BINDING_LOCATION = $Area2D/CollisionShape2D.global_position + Vector2(0,70)
	Global.BOUND = true
	print("activate")

func deactivate():
	ACTIVE = false
	Global.BOUND = false
	print("deactivate")

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("soul"):
		ENTERED = true

func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group("soul"):
		ENTERED = false
