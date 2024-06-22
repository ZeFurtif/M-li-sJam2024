extends Node2D
class_name Interactible

var SHAPE_HOLE = ShapeType.CIRCLE
var ACTIVE = false
var ENTERED = false
var LAST_ACTIVATION_TIME = 0
var LAST_BIND_ID = 0

func _process(delta):
	if ENTERED and !PlayerGlobals.PLAYING_BODY:
		if Input.is_action_just_pressed("interaction") and SHAPE_HOLE in PlayerGlobals.SOULS:
			activate()
			LAST_ACTIVATION_TIME = Time.get_ticks_msec()
	if (Time.get_ticks_msec() - LAST_ACTIVATION_TIME) >= 5000 and ACTIVE:
		deactivate()

func activate():
	ACTIVE = true
	LAST_BIND_ID = PlayerGlobals.PLAYING_SOUL
	PlayerGlobals.bind_pos(LAST_BIND_ID, $Area2D/CollisionShape2D.global_position + Vector2(0,70))
	PlayerGlobals.bind(LAST_BIND_ID)
	print("activate")
	print(LAST_BIND_ID, " ", PlayerGlobals.BOUND_POS[LAST_BIND_ID])

func deactivate():
	ACTIVE = false
	PlayerGlobals.unbind(LAST_BIND_ID)
	print("deactivate")

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("soul"):
		ENTERED = true

func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group("soul"):
		ENTERED = false
