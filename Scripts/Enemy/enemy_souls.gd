extends Node2D

@export var rotation_speed = 2

@onready var anchors = $Anchors

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anchors.rotation += rotation_speed * delta
	#print(anchors.rotation)

func _on_fire_souls_01_body_entered(body):
	print(body.name)
	if(body.name == "Body"):
		print("souls01 its player mtf")


func _on_fire_souls_02_body_entered(body):
	print(body.name)
	if(body.name == "Body"):
		print("souls02 its player mtf")


func _on_fire_souls_03_body_entered(body):
	print(body.name)
	if(body.name == "Body"):
		print("souls03 its player mtf")


func _on_fire_souls_04_body_entered(body):
	print(body.name)
	if(body.name == "Body"):
		print("souls04 its player mtf")
