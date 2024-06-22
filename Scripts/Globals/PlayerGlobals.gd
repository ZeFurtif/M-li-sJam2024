extends Node

var PLAYING_BODY = true
var PLAYING_SOUL = 0
var SOULS = []
var MAX_SOULS = 3
var SOULS_AMOUNT = 0
var BINDING_LOCATION
var BOUND = false
const BODY_SPEED = 120
const SOUL_SPEED = 150
const JUMP_VELOCITY = -250

func add_to_shape_array(shape):
	if shape in SOULS:
		print("Shape Already Remembered")
	else:
		if len(SOULS) == SOULS_AMOUNT:
			SOULS[PLAYING_SOUL] = shape
		else:
			SOULS.append(shape)
