extends Node

signal _event_damage_received(damage)

var HEALTH = 100
var PLAYING_BODY = true
var PLAYING_SOUL = 0
var SOULS = []
var BOUND = [false, false, false]
var BOUND_POS = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
var MAX_SOULS = 3
var SOULS_AMOUNT = 0
var BINDING_LOCATION
const BODY_SPEED = 120
const SOUL_SPEED = 100
const JUMP_VELOCITY = -350


func add_to_shape_array(shape):
	if shape in SOULS:
		print("Shape Already Remembered")
	else:
		if len(SOULS) == SOULS_AMOUNT:
			SOULS[PLAYING_SOUL] = shape
		else:
			SOULS.append(shape)

func bind(i):
	if i >= 0 and i < len(SOULS):
		BOUND[i] = true

func unbind(i):
	if i >= 0 and i < len(SOULS):
		BOUND[i] = false

func bind_pos(i, pos):
	if i >= 0 and i < len(SOULS):
		BOUND_POS[i] = pos

func take_damage(damage):
	_event_damage_received.emit(damage)
	HEALTH -= damage
