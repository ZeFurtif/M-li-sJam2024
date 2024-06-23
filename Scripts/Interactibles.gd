extends Node2D
class_name Interactible

@export var SHAPE_HOLE = 2
var ACTIVE = false
var ENTERED = false
var LAST_ACTIVATION_TIME = 0
var LAST_BIND_ID = 0

var anims = ["default", "key1", "key2"]

func _ready():
	$StaticBody2D/CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D/AnimatedSprite2D.visible = false
	$Area2D/CollisionShape2D/AnimatedSprite2D.play("default")
	$Sprite2D.visible = false

func _process(delta):
	if (Time.get_ticks_msec() - LAST_ACTIVATION_TIME) >= 5000 and ACTIVE:
		deactivate()
	if !PlayerGlobals.PLAYING_BODY:
		$Sprite2D.visible = true
		if ENTERED:
			if Input.is_action_just_pressed("interaction") and SHAPE_HOLE in PlayerGlobals.SOULS:
				activate()
				LAST_ACTIVATION_TIME = Time.get_ticks_msec()
	else:
		$Sprite2D.visible = false
	
func activate():
	ACTIVE = true
	LAST_BIND_ID = PlayerGlobals.PLAYING_SOUL
	PlayerGlobals.bind_pos(LAST_BIND_ID, global_position)
	PlayerGlobals.bind(LAST_BIND_ID)
	$StaticBody2D/CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D/AnimatedSprite2D.visible = true
	$Area2D/CollisionShape2D/AnimatedSprite2D.play(anims[SHAPE_HOLE])
	print("activate")
	print(LAST_BIND_ID, " ", PlayerGlobals.BOUND_POS[LAST_BIND_ID])

func deactivate():
	ACTIVE = false
	PlayerGlobals.unbind(LAST_BIND_ID)
	$StaticBody2D/CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D/AnimatedSprite2D.visible = false
	print("deactivate")

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("soul"):
		ENTERED = true

func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group("soul"):
		ENTERED = false
