tool
extends Node2D
class_name Joystick, "res://joystick/textures/icon.png"

#Note: A simple joystick for touchscreens, Developed by jstnjrg. 

onready var bigger := $bigger
onready var smaller := $bigger/smaller

export var debug_mude := false
export var max_lenght := 50.0
export(float,0,1) var smoothing := 0.3
export(float,0,1) var smoothing_return := 0.7
export var sensitivity_area := 200
export(Array,Color) var debug_colors


var pos_data : Vector2
var motion : Vector2

signal pos_changed(pos)
signal stopped_updating(pos)

func _input(event):
	
	if !(event is InputEventScreenDrag) and !(event is InputEventScreenTouch):
		return
	
	elif event is InputEventScreenDrag and bigger.transform.xform_inv(event.position).length() <= sensitivity_area:
		
		var touch_pos : Vector2 = event.position 
		var trans_pos : Vector2 = bigger.transform.xform_inv(touch_pos)
		
		smaller.position = smaller.position.linear_interpolate(trans_pos,smoothing)
		smaller.position = smaller.position.limit_length(max_lenght)
		emit_signal("pos_changed",trans_pos.normalized())
		
		#Debug
		if debug_mude: pos_data = trans_pos
	
	
	elif event is InputEventScreenTouch and not event.is_pressed() or bigger.transform.xform_inv(event.position).length() > sensitivity_area:
		emit_signal("stopped_updating",Vector2.ZERO)
		
		####Debug
		if debug_mude: pos_data = Vector2.ZERO
		
		while true:
			smaller.position = smaller.position.linear_interpolate(Vector2.ZERO,smoothing_return)
			if smaller.position.length() == 0:
				break
	
	if debug_mude:update()

func _draw():
	if not debug_mude:
		return
	_debug()

func _debug():
	draw_set_transform_matrix(bigger.transform)
	draw_circle(Vector2.ZERO,sensitivity_area,debug_colors[0])
	draw_line(Vector2.ZERO,pos_data,Color.red,4.0)

func _get_configuration_warning():
	if not get_parent() is CanvasLayer:
		return "For it to be fixed on the screen, this scene must be sonof a CanvasLayer"
	return ""
