extends Node2D

func _ready():
	print("called_cam")
	$Player.lock_cam_y(-190)
