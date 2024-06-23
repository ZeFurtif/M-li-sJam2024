extends Node

var soul_target = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_damage = 0
var shake_speed = 2
var shake_amplitude = 0


var IN_MENU = false
var LOCKED_CAM_Y = false

func _ready():
	soul_target = $Body.position + Vector2(0, -20)
	PlayerGlobals._event_damage_received.connect(_on_health_change)
	$Body/Camera2D/CanvasLayer.visible = true

func _process(delta):
	if PlayerGlobals.SOULS_AMOUNT < PlayerGlobals.MAX_SOULS:
		spawn_soul()
	
	if Input.is_action_just_pressed("menu"):
		IN_MENU = !IN_MENU
		if IN_MENU:
			$Body/Camera2D/CanvasLayerUI/MENU/Resume.grab_focus()
	$Body/Camera2D/CanvasLayerUI/MENU.visible = IN_MENU
	$Body/Camera2D/CanvasLayer/CRT.visible = IN_MENU
	if IN_MENU:
		return
	
	if PlayerGlobals.SOULS_AMOUNT > 0 and Input.is_action_just_pressed("switch"):
		PlayerGlobals.PLAYING_BODY = !PlayerGlobals.PLAYING_BODY
		reset_soul_arrow()

	if !PlayerGlobals.PLAYING_BODY and (Input.is_action_just_pressed("switch_down") or Input.is_action_just_pressed("switch_up")):
		var switch = Input.get_axis("switch_up", "switch_down")
		PlayerGlobals.PLAYING_SOUL += int(switch)
		PlayerGlobals.PLAYING_SOUL = (PlayerGlobals.PLAYING_SOUL+ PlayerGlobals.SOULS_AMOUNT)%PlayerGlobals.SOULS_AMOUNT
			
	if Input.is_action_just_pressed("spawn_soul"):
		spawn_soul()		
	if Input.is_action_just_pressed("kill_soul"):
		kill_soul()
		#PlayerGlobals.take_damage(5)
	
	handle_attack()
	
	if PlayerGlobals.PLAYING_BODY:
		handle_body_movement(delta)
		set_soul_vignette(0)
	else: 
		handle_soul_movement(delta)
		handle_body_follow(delta)
		set_soul_vignette(1)
	handle_soul_follow(delta)
	handle_soul_bound(delta)
	show_soul_arrow()
	shake_cam()
	shake_amplitude = move_toward(shake_amplitude, 0, 0.1)

	if Time.get_ticks_msec() - last_damage > 500:
		set_chromatic_aberration(1,0.7)

func handle_body_movement(delta):
	var body = find_child("Body")
	var jumped = false
	if not body.is_on_floor():
		body.velocity.y += gravity * delta
	if Input.is_action_pressed("jump") and body.is_on_floor():
		body.velocity.y = PlayerGlobals.JUMP_VELOCITY
		jumped = true

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		body.velocity.x = direction * PlayerGlobals.BODY_SPEED
		if body.velocity.x < 0:
			body.find_child("AnimatedSprite2D").flip_h = true
		if body.velocity.x > 0:
			body.find_child("AnimatedSprite2D").flip_h = false
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, PlayerGlobals.BODY_SPEED)
	handle_body_animations(direction, jumped)
	body.move_and_slide()

func handle_body_follow(delta):
	var body = find_child("Body")
	body.velocity.x = 0
	if not body.is_on_floor():
		body.velocity.y += gravity * delta
	body.move_and_slide()

func handle_body_animations(direction, jump):
	if $Body/AnimatedSprite2D.animation in ["attack1", "attack2"] and $Body/AnimatedSprite2D.is_playing():
		return
	if $Body.is_on_floor():
		if direction == 0:
			$Body/AnimatedSprite2D.play("idle")
		else:
			$Body/AnimatedSprite2D.play("walk")
	else:
		if $Body.velocity.y < 0:
			$Body/AnimatedSprite2D.play("jump")
		elif $Body.velocity.y >= 0:
			$Body/AnimatedSprite2D.play("falling")

func handle_soul_movement(delta):
	var souls = get_children()
	var current_idx = 0
	for soul in souls:
		if soul.is_in_group("soul"):
			if current_idx == PlayerGlobals.PLAYING_SOUL and !PlayerGlobals.BOUND[current_idx]:
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
				return
			current_idx += 1

func handle_soul_follow(delta):
	var souls = get_children()
	var current_idx = 0
	for soul in souls:
		if soul.is_in_group("soul"):
			if !PlayerGlobals.BOUND[current_idx]:
				if PlayerGlobals.PLAYING_BODY or current_idx != PlayerGlobals.PLAYING_SOUL:
					soul_target.x = move_toward(soul_target.x, $Body.position.x, 1*10)
					soul_target.y = move_toward(soul_target.y, $Body.position.y, 1*10)
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

func handle_soul_bound(delta):
	var souls = get_children()
	var current_idx = 0
	for soul in souls:
		if soul.is_in_group("soul"):
			if PlayerGlobals.BOUND[current_idx]:
				soul.velocity.x = (PlayerGlobals.BOUND_POS[current_idx].x - soul.position.x) * delta * PlayerGlobals.SOUL_SPEED
				soul.velocity.y = (PlayerGlobals.BOUND_POS[current_idx].y - soul.position.y) * delta * PlayerGlobals.SOUL_SPEED
			current_idx += 1

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
				PlayerGlobals.SOULS.pop_front()
				return

func _on_health_change(damage):
	last_damage = Time.get_ticks_msec()
	if damage > 0:
		set_chromatic_aberration(10, 0.01)
		shake_amplitude = 20
		$Body/AnimatedSprite2D.play("hit")

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

func set_chromatic_aberration(strenght, fade):
	var cur_r = $Body/Camera2D/CanvasLayer/ChromaticAberation.material.get("shader_parameter/r_displacement")
	var cur_b = $Body/Camera2D/CanvasLayer/ChromaticAberation.material.get("shader_parameter/b_displacement")
	var cur_fade = $Body/Camera2D/CanvasLayer/ChromaticAberation.material.get("shader_parameter/fade")
	var new_r = Vector2(strenght*3,0)
	var new_b = Vector2(strenght*-3,0)
	var new_fade = move_toward(cur_fade, fade, 10)
	new_r.x = move_toward(cur_r.x, new_r.x, 10)
	new_b.x = move_toward(cur_b.x, new_b.x, 10)
	$Body/Camera2D/CanvasLayer/ChromaticAberation.material.set("shader_parameter/r_displacement",new_r)
	$Body/Camera2D/CanvasLayer/ChromaticAberation.material.set("shader_parameter/b_displacement",new_b)
	$Body/Camera2D/CanvasLayer/ChromaticAberation.material.set("shader_parameter/fade",new_fade)

func shake_cam():
	if shake_amplitude == 0:
		$Body/Camera2D.position = Vector2(0,0)
		return
	$Body/Camera2D.position = Vector2(sin(Time.get_ticks_msec()+50*shake_speed),sin(Time.get_ticks_msec()*shake_speed)) * shake_amplitude


func _on_resume_pressed():
	IN_MENU = false

func _on_quit_pressed():
	get_tree().quit()

func _on_title_menu_pressed():
	get_tree().change_scene_to_file("res://Levels/MENU/title_menu.tscn")

func handle_attack():
	if Input.is_action_just_pressed("attack"):
		var attacks = ["attack1", "attack2"]
		$Body/AnimatedSprite2D.play(attacks[randi_range(0,1)])

func lock_cam_y(value):
	LOCKED_CAM_Y = !LOCKED_CAM_Y
	$Body/Camera2D.set("limit_top", $Body.position.y+value)
	$Body/Camera2D.set("limit_bottom", $Body.position.y+value)
