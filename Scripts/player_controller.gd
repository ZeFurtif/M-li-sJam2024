extends Node2D

const SPEED = 80
const JUMP_VELOCITY = -300

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _process(delta):
	if not $Body.is_on_floor():
		$Body.velocity.y += gravity * delta
	
	if Input.is_action_pressed("jump") and $Body.is_on_floor():
		$Body.velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		$Body.velocity.x = direction * SPEED
		if $Body.velocity.x < 0:
			$Body/AnimatedSprite2D.flip_h = true
		if $Body.velocity.x > 0:
			$Body/AnimatedSprite2D.flip_h = false
	else:
		$Body.velocity.x = move_toward($Body.velocity.x, 0, SPEED)
		
	$Body.move_and_slide()
