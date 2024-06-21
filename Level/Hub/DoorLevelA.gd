extends Area2D


	
func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("interaction"):
			get_tree().change_scene_to_file("res://Level/Hub/LevelA.tscn")
