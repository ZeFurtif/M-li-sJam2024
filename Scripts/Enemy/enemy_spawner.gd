extends Node2D

var enemy = preload("res://Prefabs/enemy.tscn")

var spawn_time = 0
var lifetime = 10000

func _ready():
	spawn_time = Time.get_ticks_msec()

func _process(delta):
	if Time.get_ticks_msec() - spawn_time >= lifetime:
		spawn_time = Time.get_ticks_msec()
		spawn_enemy()

func spawn_enemy():
	var enemy_copy = enemy.instantiate()
	enemy_copy.position = Vector2(0, position.y)
	enemy_copy.set("myType", randi_range(0,3))
	add_child(enemy_copy)
