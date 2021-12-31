extends Node2D

var pressed = false
var active_line


func _ready():
	pass


func _on_canvas_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			pressed = true
			active_line = Line2D.new()
			active_line.default_color = Color("#fcba03") # get_node("ColorPicker").color
			active_line.width = 10.0
		else:
			pressed = false
	
	if event is InputEventMouseMotion:
		if pressed:
			active_line.add_point(event.position)
			add_child(active_line)
