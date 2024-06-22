extends Node2D

@export var speed = 2

@onready var anchors = $Anchors

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anchors.rotation = speed * delta
	print(anchors.rotation)

#func _on_fire_souls_01_body_entered(body):
#	queue_free()
#	if(body.has_node("player")):
#		print("its player mtf")
