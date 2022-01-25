extends Node2D

var old_camera_position:Vector3 = Vector3(0, 0, 0)
var pressed = false
var lines = []
var active_line


func _ready():
	pass


func _on_canvas_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			pressed = true
			active_line = Line2D.new()
			active_line.default_color = Color("#fcba03") # get_node("ColorPicker").color
			active_line.width = 10.00
			lines.append(active_line)
		else:
			pressed = false
	
	if event is InputEventMouseMotion:
		if pressed:
			active_line.add_point(event.position)
			add_child(active_line)

func update_position(new_camera_position):
	var camera_change:Vector2 = _calc_change_in_camera_position(old_camera_position, new_camera_position)
	
	for line in lines:
		var i = 0
		for point in line.points:
			var new_position = Vector2(point.x + camera_change.x, point.y + camera_change.y) * 1.1
			line.set_point_position(i, new_position)
			
			i += 1

func _calc_change_in_camera_position(old_camera_position, new_camera_position):
	# TODO: Calc the change between old and new camera position
	return Vector2(
		old_camera_position.x - new_camera_position.x,
		old_camera_position.y - new_camera_position.y
	)
