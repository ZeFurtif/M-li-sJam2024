extends Area2D

var entered = false
var pscene = load("res://Levels/HUB/LevelHub.tscn")

func _ready():
	entered = false


func _process(_delta):
	if entered == true:
		if Input.is_action_just_pressed("interaction"):
			PlayerGlobals.new_scene()
			get_tree().change_scene_to_packed(pscene)

func _on_body_exited(body):
	if body.is_in_group("player_body"):
		entered = false
		print("can intered set on: ", entered)


func _on_body_entered(body):
	if body.is_in_group("player_body"):
		entered = true
		print("can intered set on: ", entered)
