extends Node2D

var PLAYING_BODY = true

const BODY_SPEED = 80
const SOUL_SPEED = 90
const JUMP_VELOCITY = -300

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _process(delta):
	
	if Input.is_action_just_pressed("switch"):
		PLAYING_BODY = !PLAYING_BODY
	
	if PLAYING_BODY:
		handle_body_movement(delta)
	else:
		handle_soul_movement(delta)

func handle_body_movement(delta):
	if not $Body.is_on_floor():
		$Body.velocity.y += gravity * delta
	
	if Input.is_action_pressed("jump") and $Body.is_on_floor():
		$Body.velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		$Body.velocity.x = direction * BODY_SPEED
		if $Body.velocity.x < 0:
			$Body/AnimatedSprite2D.flip_h = true
		if $Body.velocity.x > 0:
			$Body/AnimatedSprite2D.flip_h = false
	else:
		$Body.velocity.x = move_toward($Body.velocity.x, 0, BODY_SPEED)
		
	$Body.move_and_slide()

func handle_soul_movement(delta):
	var direction = Input.get_vector("move_left", "move_right","move_up", "move_down")
	direction = direction.normalized()
	if direction:
		$Soul.velocity = direction * SOUL_SPEED
		if $Soul.velocity.x < 0:
			$Soul/AnimatedSprite2D.flip_h = true
		if $Soul.velocity.x > 0:
			$Soul/AnimatedSprite2D.flip_h = false
	else:
		$Soul.velocity.x = move_toward($Soul.velocity.x, 0, SOUL_SPEED)
		$Soul.velocity.y = move_toward($Soul.velocity.y, 0, SOUL_SPEED)
			
	$Soul.move_and_slide()


