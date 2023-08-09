extends Sprite

var speed := 200.0
var motion : Vector2


func _process(delta):
	rotation = motion.angle() if motion.length() > 0 else rotation
	translate(motion*speed*delta)

func _on_Joystick_pos_changed(pos):
	#YOU DO NOT NEED TO NORMALIZE THE RECEIVED pos OF THE SIGNALS
	motion = pos

func _on_Joystick_stopped_updating(pos):
	#YOU DO NOT NEED TO NORMALIZE THE RECEIVED pos OF THE SIGNALS
	motion = pos
