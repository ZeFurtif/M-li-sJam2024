extends Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum EnemyType {MOUCHE, FOURBE, MAG, TANK}

@export var myType = EnemyType.MAG
var HEALTH = 2**myType
var SPEED = 30
var PLAYER_IN_RANGE = false
var PLAYER_IN_SIGHT = false
var player

var last_attack_time = 2000
var cooldown = 3000

@onready var animated_sprite_2d = $Enemy_Body/AnimatedSprite2D
@onready var raycast = $Enemy_Body/RayCast2D

func _ready():
	$Enemy_Body.motion_mode = 1

func _process(delta):
	#detect si le player est vu à chaque frames
	if PLAYER_IN_RANGE:
		#fonction qui detect le joueur à l'aide d'un raycast
		cast_to_player()
		if PLAYER_IN_SIGHT:
			#fonction qui déplace l'ennemi vers le joueur
			walk_to_player()
			#envoie d'une boule de feu vers le joueur
			throw_at_player()
	
func walk_to_player():
	var target = (player.position + Vector2(0,-50) - raycast.global_position)
	#verifie quel type d'ennemi est il
	if myType == EnemyType.MAG:
		#distance de la position de l'enemy par rapport au joueur, l'enemy va reculer si il est trop près du joueure et inversement si il est trop loin
		if target.length() > 150:
			$Enemy_Body.velocity = target.normalized() * SPEED
		elif target.length() < 50:
			$Enemy_Body.velocity = -target.normalized() * SPEED
	$Enemy_Body.move_and_slide()
			

#fonction qui detect le joueur à l'aide d'un raycast
func cast_to_player():
	#raycast(start = la_position_du_joueur, la_position_global_du_raycast + une correction qui "tire" vers)
	raycast.target_position = player.position - raycast.global_position + Vector2(0,-50)
	#on récupère le collider du raycast
	var col = raycast.get_collider()
	#si la collision du raycast est le joueur alors le joueur est "vu"
	if col:
		if col.is_in_group("player_body"):
			PLAYER_IN_SIGHT = true
		else:
			PLAYER_IN_SIGHT = false
	else:
		PLAYER_IN_SIGHT = false

func throw_at_player():
	#cooldown d'attaque
	if Time.get_ticks_msec() - last_attack_time >= cooldown:
		last_attack_time = Time.get_ticks_msec()
		
		#on load l'object d'abord
		var bullet = load("res://Prefabs/enemy_souls.tscn")
		#on instantie ensuite l'object
		var bullet_copy = bullet.instantiate()
		#puis on le créé dans la scene avec "add_child"
		add_child(bullet_copy)
		
		var rb = bullet_copy.get_child(0)
		rb.position = $Enemy_Body.position + Vector2(0, -20)
		rb.apply_central_impulse((player.position - raycast.global_position + Vector2(0,-50)).normalized() * 360)

#fonction qui verifie si le joueur est en range
func _on_player_range_body_entered(body):
	if body.is_in_group("player_body"):
		PLAYER_IN_RANGE = true
		player = body
		
#fonction qui verifie si le joueur est hors range
func _on_player_range_body_exited(body):
	if body.is_in_group("player_body"):
		PLAYER_IN_RANGE = false
