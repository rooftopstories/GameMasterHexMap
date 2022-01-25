extends Camera


const MOVE_MARGIN = 20
const MOVE_SPEED = 15

var scroll_edges:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	scroll_edges = get_parent().scroll_edges

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scroll_edges:
		var m_pos = get_viewport().get_mouse_position()
		calc_move(m_pos, delta)

func calc_move(m_pos, delta):
	var v_size = get_viewport().size
	var move_vec = Vector3()
	
	if m_pos.x < MOVE_MARGIN:
		move_vec.x -= 1
	if m_pos.y < MOVE_MARGIN:
		move_vec.z -= 1
		
	if m_pos.x > v_size.x - MOVE_MARGIN:
		move_vec.x += 1
	if m_pos.y > v_size.y - MOVE_MARGIN:
		move_vec.z += 1

	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation_degrees.y)
	global_translate(move_vec * delta * MOVE_SPEED)

var _previousPosition: Vector2 = Vector2(0, 0)
var _moveCamera: bool = false

func _unhandled_input(event: InputEvent):
	var options = get_node("/root/options")
	if options.mode == 'map':
		if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
			# LEFT Mouse Click
			# get_tree().set_input_as_handled();
			if event.is_pressed():
				_previousPosition = event.position
				_moveCamera = true
			else:
				_moveCamera = false
				
		elif event is InputEventMouseMotion && _moveCamera:
			# LEFT Mouse Drag
			get_tree().set_input_as_handled()
			# position += (_previousPosition - event.position);
			var new_position:Vector2 = (_previousPosition - event.position)
			
			var position_vector:Vector3 = Vector3(new_position.x, 0, new_position.y) * 0.03
			get_parent().get_child(0).update_position(position_vector)
			global_translate(position_vector)
			_previousPosition = event.position

		elif event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_UP:
			# MOUSE WHEEL UP
			var zoom_pos = event.position
			print('wheel up')
			global_translate(Vector3(0, -1, 0))
		elif event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_DOWN:
			# MOUSE WHEEL DOWN
			var zoom_pos = event.position
			print('wheel down')
			global_translate(Vector3(0, 1, 0))
