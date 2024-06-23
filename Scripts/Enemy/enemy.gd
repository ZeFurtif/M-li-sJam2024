extends Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum EnemyType {MOUCHE, FOURBE, MAG, TANK}

var myType = EnemyType.MAG
var HEALTH = 2**myType
var SPEED = 30
var PLAYER_IN_RANGE = false
var PLAYER_IN_SIGHT = false
var player

var last_attack_time = 0
var cooldown = 3000

@onready var animated_sprite_2d = $Enemy_Body/AnimatedSprite2D
@onready var raycast = $Enemy_Body/RayCast2D

func _ready():
	$Enemy_Body.motion_mode = 1

func _process(delta):
	if PLAYER_IN_RANGE:
		cast_to_player()
		if PLAYER_IN_SIGHT:
			walk_to_player()
			throw_at_player()
	
func walk_to_player():
	var target = (player.position + Vector2(0,-50) - raycast.global_position)
	if myType == EnemyType.MAG:
		if target.length() > 150:
			$Enemy_Body.velocity = target.normalized() * SPEED
		elif target.length() < 50:
			$Enemy_Body.velocity = -target.normalized() * SPEED
	$Enemy_Body.move_and_slide()
			

func cast_to_player():
	raycast.target_position = player.position - raycast.global_position + Vector2(0,-50)
	var col = raycast.get_collider()
	if col:
		if col.is_in_group("player_body"):
			PLAYER_IN_SIGHT = true
		else:
			PLAYER_IN_SIGHT = false
	else:
		PLAYER_IN_SIGHT = false

func throw_at_player():
	if Time.get_ticks_msec() - last_attack_time >= cooldown:
		last_attack_time = Time.get_ticks_msec()
		var bullet = load("res://Prefabs/enemy_souls.tscn")
		var bullet_copy = bullet.instantiate()
		add_child(bullet_copy)
		var rb = bullet_copy.get_child(0)
		rb.position = $Enemy_Body.position + Vector2(0, -20)
		rb.apply_central_impulse((player.position - raycast.global_position + Vector2(0,-50)).normalized() * 360)

func _on_player_range_body_entered(body):
	if body.is_in_group("player_body"):
		PLAYER_IN_RANGE = true
		player = body

func _on_player_range_body_exited(body):
	if body.is_in_group("player_body"):
		PLAYER_IN_RANGE = false
