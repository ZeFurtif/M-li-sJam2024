extends Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var speed = 60
@export var enemy_name = "Enemy_04"
#@export var enemy_type = EnemyGlobals.type[1]

var direction = 1

@onready var raycast_left = $Enemy_Body/RayCast2DLeft
@onready var raycast_right = $Enemy_Body/RayCast2DRight
@onready var animated_sprite_2d = $Enemy_Body/AnimatedSprite2D

func _ready():
	print("Name: " + enemy_name)
	print("Speed: ", speed)

func _process(delta):
	handle_body_movement(delta)
	CheckRaycast()
	position.x += direction * speed * delta
	#print(self.position)
	
func handle_body_movement(delta):
	var body = find_child("Enemy_Body")
	if not body.is_on_floor():
		body.velocity.y += gravity * delta
	body.move_and_slide()

func CheckRaycast():
	if raycast_left.is_colliding():
		animated_sprite_2d.flip_h = true
		direction = 1
	if raycast_right.is_colliding():
		animated_sprite_2d.flip_h = false
		direction = -1
