extends Node2D

var spawn_time = 0
var lifetime = 1500

func _ready():
	spawn_time = Time.get_ticks_msec()

func _process(delta):
	if Time.get_ticks_msec() - spawn_time >= lifetime:
		queue_free()

func _on_area_2d_body_entered(body):
	if(body.is_in_group("player_body")):
		PlayerGlobals.take_damage(2)
		queue_free()
