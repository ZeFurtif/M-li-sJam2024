extends Node

var PLAYING_BODY = true
var SOULS = [ShapeType.NONE]
var MAX_SOULS = 3
var SOULS_AMOUNT = 0
var BINDING_LOCATION
var BOUND = false
const BODY_SPEED = 120
const SOUL_SPEED = 150
const JUMP_VELOCITY = -250

func add_to_shape_array(shape):
	if shape not in SOULS:
		if len(SOULS) == MAX_SOULS:
			SOULS[0] == shape
		else:
			SOULS.append(shape)
