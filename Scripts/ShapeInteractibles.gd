extends Node2D
class_name Shape

@export var SHAPE = 2
var ENTERED = false

var anims = ["default", "key1", "key2"]

func _ready():
	$Area2D/AnimatedSprite2D.play(anims[SHAPE])
	$Area2D/ghost.visible = false

func _process(delta):
	if !PlayerGlobals.PLAYING_BODY:
		$Area2D/ghost.visible = true
		if ENTERED:
			if Input.is_action_just_pressed("interaction"):
				PlayerGlobals.add_to_shape_array(SHAPE)
				print(PlayerGlobals.SOULS)
	else:
		$Area2D/ghost.visible = false

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("soul"):
		print("yes")
		ENTERED = true

func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group("soul"):
		ENTERED = false

