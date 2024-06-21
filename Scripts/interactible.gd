extends Area2D
class_name Interactible

var SHAPE_HOLE = ShapeType.CIRCLE
var ACTIVE = false
var ENTERED = false
var LAST_ACTIVATION_TIME = 0

func _on_body_entered(body: PhysicsBody2D):
	ENTERED = true

func _on_body_exited(body):
	ENTERED = false
	
func _process(delta):
	if Input.is_action_just_pressed("interaction") and not ACTIVE:
		activate()
		LAST_ACTIVATION_TIME = Time.get_ticks_msec()
	if (Time.get_ticks_msec() - LAST_ACTIVATION_TIME) >= 5000 and ACTIVE:
		deactivate()

func activate():
	pass

func deactivate():
	pass
