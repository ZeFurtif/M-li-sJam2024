extends Node2D
class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("switch"):
		Global.PLAYING_BODY = !Global.PLAYING_BODY
	
	if Global.PLAYING_BODY:
		handle_body_movement(delta) # INPUTS -> BODY MOVEMENT
		handle_soul_follow(delta) # SOUL FOLLOWS BODY
	else:
		handle_soul_movement(delta) # INPUTS -> SOUL MOVEMENT
		
func handle_body_movement(delta):
	if not $Body.is_on_floor():
		$Body.velocity.y += gravity * delta
	
	if Input.is_action_pressed("jump") and $Body.is_on_floor():
		$Body.velocity.y = Global.JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		$Body.velocity.x = direction * Global.BODY_SPEED
		if $Body.velocity.x < 0:
			$Body/AnimatedSprite2D.flip_h = true
		if $Body.velocity.x > 0:
			$Body/AnimatedSprite2D.flip_h = false
	else:
		$Body.velocity.x = move_toward($Body.velocity.x, 0, Global.BODY_SPEED)
		
	$Body.move_and_slide()

func handle_soul_movement(delta):
	if (Global.BOUND):
		go_to_binding_location(delta)
	else:
		var direction = Input.get_vector("move_left", "move_right","move_up", "move_down")
		direction = direction.normalized()
		if direction:
			$Soul.velocity = direction * Global.SOUL_SPEED
			if $Soul.velocity.x < 0:
				$Soul/AnimatedSprite2D.flip_h = true
			if $Soul.velocity.x > 0:
				$Soul/AnimatedSprite2D.flip_h = false
		else:
			$Soul.velocity.x = move_toward($Soul.velocity.x, 0, Global.SOUL_SPEED)
			$Soul.velocity.y = move_toward($Soul.velocity.y, 0, Global.SOUL_SPEED)
				
	$Soul.move_and_slide()

func handle_soul_follow(delta):
	if (Global.BOUND):
		go_to_binding_location(delta)
	else:
		var target = $Body.position + Vector2(0,-30)
		if not $Body/AnimatedSprite2D.flip_h:
			target.x -= 30
		else:
			target.x += 30
		$Soul.velocity.x = (target.x - $Soul.position.x) * delta * Global.SOUL_SPEED
		$Soul.velocity.y = (target.y - $Soul.position.y) * delta * Global.SOUL_SPEED
		if $Soul.velocity.x < 0:
			$Soul/AnimatedSprite2D.flip_h = true
		if $Soul.velocity.x > 0:
			$Soul/AnimatedSprite2D.flip_h = false

	$Soul.move_and_slide()

func go_to_binding_location(delta):
	$Soul.velocity.x = (Global.BINDING_LOCATION.x - $Soul.position.x) * delta * Global.SOUL_SPEED
	$Soul.velocity.y = (Global.BINDING_LOCATION.y - $Soul.position.y) * delta * Global.SOUL_SPEED
