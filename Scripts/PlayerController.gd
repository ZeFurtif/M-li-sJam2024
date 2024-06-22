extends Node

var soul_target = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	soul_target = $Body.position + Vector2(0, -20)

func _process(delta):
	if Input.is_action_just_pressed("switch"):
		if PlayerGlobals.PLAYING_BODY:
			PlayerGlobals.PLAYING_BODY = false
			PlayerGlobals.PLAYING_SOUL = 0
			reset_soul_arrow()
		else:
			if PlayerGlobals.PLAYING_SOUL >= PlayerGlobals.SOULS_AMOUNT-1:
				PlayerGlobals.PLAYING_BODY = true
			else:
				PlayerGlobals.PLAYING_SOUL += 1
	if Input.is_action_just_pressed("spawn_soul"):
		spawn_soul()		
	if Input.is_action_just_pressed("kill_soul"):
		kill_soul()
		
	if PlayerGlobals.PLAYING_BODY:
		handle_body_movement(delta)
		set_soul_vignette(0)
	else: 
		handle_soul_movement(delta)
		handle_body_follow(delta)
		set_soul_vignette(1)
	handle_soul_follow(delta)
	show_soul_arrow()

func handle_body_movement(delta):
	var body = find_child("Body")
	if not body.is_on_floor():
		body.velocity.y += gravity * delta
	
	if Input.is_action_pressed("jump") and body.is_on_floor():
		body.velocity.y = PlayerGlobals.JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		body.velocity.x = direction * PlayerGlobals.BODY_SPEED
		if body.velocity.x < 0:
			body.find_child("AnimatedSprite2D").flip_h = true
		if body.velocity.x > 0:
			body.find_child("AnimatedSprite2D").flip_h = false
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, PlayerGlobals.BODY_SPEED)
	body.move_and_slide()

func handle_body_follow(delta):
	var body = find_child("Body")
	body.velocity.x = 0
	if not body.is_on_floor():
		body.velocity.y += gravity * delta
	body.move_and_slide()

func handle_soul_movement(delta):
	var souls = get_children()
	var current_idx = 0
	for soul in souls:
		if soul.is_in_group("soul"):
			if current_idx == PlayerGlobals.PLAYING_SOUL:
				if (PlayerGlobals.BOUND):
					soul.velocity.x = (PlayerGlobals.BINDING_LOCATION.x - soul.position.x) * delta * PlayerGlobals.SOUL_SPEED
					soul.velocity.y = (PlayerGlobals.BINDING_LOCATION.y - soul.position.y) * delta * PlayerGlobals.SOUL_SPEED
				else:
					var direction = Input.get_vector("move_left", "move_right","move_up", "move_down")
					direction = direction.normalized()
					if direction:
						soul.velocity = direction * PlayerGlobals.SOUL_SPEED
						if soul.velocity.x < 0:
							soul.find_child("AnimatedSprite2D").flip_h = true
						if soul.velocity.x > 0:
							soul.find_child("AnimatedSprite2D").flip_h = false
					else:
						soul.velocity.x = move_toward(soul.velocity.x, 0, PlayerGlobals.SOUL_SPEED)
						soul.velocity.y = move_toward(soul.velocity.y, 0, PlayerGlobals.SOUL_SPEED)
					soul.move_and_slide()
			current_idx += 1

func handle_soul_follow(delta):
	var souls = get_children()
	var current_idx = 0
	for soul in souls:
		if soul.is_in_group("soul"):
			if (PlayerGlobals.BOUND) and current_idx == PlayerGlobals.PLAYING_SOUL:
				soul.velocity.x = (PlayerGlobals.BINDING_LOCATION.x - soul.position.x) * delta * PlayerGlobals.SOUL_SPEED
				soul.velocity.y = (PlayerGlobals.BINDING_LOCATION.y - soul.position.y) * delta * PlayerGlobals.SOUL_SPEED
			else:
				if PlayerGlobals.PLAYING_BODY or current_idx != PlayerGlobals.PLAYING_SOUL:
					soul_target.x = move_toward(soul_target.x, $Body.position.x, 0.7)
					soul_target.y = move_toward(soul_target.y, $Body.position.y, 0.7)
					var target = soul_target + Vector2(-25*(current_idx-1),-30)
					var rdm = sin(Time.get_ticks_msec()*0.0005*(current_idx+1))*10
					target.y += rdm
					if not $Body/AnimatedSprite2D.flip_h:
						target.x += -20
						target.y += -7*(current_idx-1)
					else:
						target.x += 20
						target.y += 7*(current_idx-1)
					soul.velocity.x = (target.x - soul.position.x) * delta * PlayerGlobals.SOUL_SPEED
					soul.velocity.y = (target.y - soul.position.y) * delta * PlayerGlobals.SOUL_SPEED
					if soul.velocity.x < 0:
						soul.find_child("AnimatedSprite2D").flip_h = true
					if soul.velocity.x > 0:
						soul.find_child("AnimatedSprite2D").flip_h = true
					current_idx += 1
					soul.move_and_slide()

func spawn_soul():
	if (PlayerGlobals.SOULS_AMOUNT < PlayerGlobals.MAX_SOULS):
		var soul = preload("res://Prefabs/soul.tscn")
		var new_soul = soul.instantiate()
		add_child(new_soul)
		PlayerGlobals.SOULS_AMOUNT += 1
		PlayerGlobals.SOULS.append(ShapeType.NONE)

func kill_soul():
	if (PlayerGlobals.SOULS_AMOUNT > 0):
		var souls = get_children()
		for soul in souls:
			if soul.is_in_group("soul"):
				soul.queue_free()
				PlayerGlobals.SOULS_AMOUNT -= 1
				PlayerGlobals.SOULS.pop()
				return

#func handle_soul_beam():
#	var souls = get_children()
#	var current_idx = 0
#	for soul in souls:
#		if soul.is_in_group("soul"):
#			var path = soul.find_child("LinePath2D")
#			path._curve.set_point_position(0, Vector2(0,0))
#			path._curve.set_point_position(1, $Body.position - soul.position)
#			var new_out = ($Body.position-soul.position).normalized()
#			var new_in = (soul.position-$Body.position).normalized()
#			path._curve.set_point_out(0, new_out * 10)
#			path._curve.set_point_in(1, new_in * 10)
#			current_idx += 1

func show_soul_arrow():
	if PlayerGlobals.PLAYING_BODY:
		return reset_soul_arrow()
	var cur_idx = 0
	var souls = get_children()
	for soul in souls:
		if soul.is_in_group("soul"):
			soul.find_child("Arrow").set("visible", PlayerGlobals.PLAYING_SOUL == cur_idx)
			cur_idx += 1

func reset_soul_arrow():
	var souls = get_children()
	for soul in souls:
		if soul.is_in_group("soul"):
			soul.find_child("Arrow").set("visible", false)

func set_soul_vignette(alpha):
	var cur_alpha = $Body/Camera2D/CanvasLayer/SoulVignette.material.get("shader_parameter/alpha")
	$Body/Camera2D/CanvasLayer/SoulVignette.material.set("shader_parameter/alpha",move_toward(cur_alpha, alpha, 0.1))
