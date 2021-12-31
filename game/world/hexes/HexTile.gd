extends RigidBody

var current_object = null
onready var center_point = global_transform.origin

var current_edit_options:EditOptions = EditOptions.new()
var current_placement:Placement = Placement.new(self)

var player = null

func _ready():
	pass

func _process(delta):
	pass

func interact(interaction):
	if current_object:
		current_object.interact(interaction)
	
	return interaction

func _on_HexTile_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			print("Hex Left Mouse Button")
		if event.button_index == BUTTON_LEFT and event.pressed == false:
			print("Hex Left Mouse Button Release")
		if event.button_index == BUTTON_RIGHT and event.pressed == true:
			print("Hex Pressed Right Mouse Button")
		if event.button_index == BUTTON_RIGHT and event.pressed == false:
			print("Hex Right Mouse Button Release")
		if event.button_index == BUTTON_MIDDLE and event.pressed == true:
			print("Hex Pressed Middle Mouse Button")
		if event.button_index == BUTTON_MIDDLE and event.pressed == false:
			print("Hex Middle Mouse Button Release")
		if event.button_index == BUTTON_LEFT and event.doubleclick == true:
			print("Hex Left Mouse Button Double Clicked")

func remove_player(player):
	remove_child(player)
	show_object(true)

func add_player(player):
	add_child(player)
	show_object(false)

func add_content(state, content):
	match state:
		'textures':
			set_texture(content)
		'objects':
			set_object(content)
		'triggers':
			set_trigger(content)

func set_trigger(trigger):
	if current_object:
		current_object.add_trigger(trigger)

func set_texture(texture_path):
	var texture = ImageTexture.new()
	var image = Image.new()
	var mesh = $CollisionShape/MeshInstance
	
	image.load(texture_path)
	texture.create_from_image(image)
	
	# var material = mesh.get_surface_material(0)
	var material = SpatialMaterial.new()
	material.albedo_texture = texture
	material.uv1_triplanar = true
	mesh.set_surface_material(0, material)

func set_object(object):
	var is_player = false
	var curr_object_script = load(object)
	
	if object == "res://player/player.tscn":
		is_player = true
	
	if is_player:
		
		player = curr_object_script.instance()
		add_player(player)
		player.set_owner(self.get_parent())
	else:
		if current_object:
			remove_child(current_object)
			current_object.queue_free()
			
		current_object = curr_object_script.instance()
		
		if get_parent().get_parent().tactic_view:
			current_object.set_tactic_view()
		else:
			current_object.set_object_view()
		
		add_child(current_object)
		current_object.set_owner(self.get_parent())

func get_destination_tile(direction, movement):
	return current_placement.get_new_tile(direction, movement)

func show_object(show):
	if current_object:
		if show:
			current_object.show()
		else:
			current_object.hide()

class EditOptions:
	var max_height_steps:int = 5
	var min_height_steps:int = 0
	var current_height_step:int = 0
	var step_height:float = 0.25
	
	func is_growable(direction):
		match direction:
			'up':
				return current_height_step + 1 <= max_height_steps
			'down':
				return current_height_step - 1 >= min_height_steps
	
	func get_step_height(direction):
		match direction:
			'up':
				return step_height
			'down':
				return -step_height

class Placement:
	var current_tile:RigidBody = null
	var physics_space_state:PhysicsDirectSpaceState = null
	
	func _init(current_tile):
		self.current_tile = current_tile
	
	func get_new_tile(direction, movement):
		var camera = get_camera()
		var to = get_check_point(direction, movement)
		# var from = camera.project_ray_origin(new_point)
		# var to = from + camera.project_ray_normal(new_point) * 1000
		var from = camera.global_transform.origin
		var dict_hitted_objects = current_tile.get_world().get_direct_space_state().intersect_ray(from, to)
		
		if dict_hitted_objects:
			return dict_hitted_objects['collider']
		else:
			return null
		
	func get_camera():
		return current_tile.get_parent().get_child(0)
	
	func get_global_center():
		return current_tile.global_transform.origin

	func get_tile_height():
		return current_tile.get_scale().z
	
	func get_tile_width():
		return current_tile.get_scale().x
	
	func get_check_point(direction, movement):
		var tile_center = get_global_center()
		match direction:
			movement.move_direction.up:
				return Vector3(tile_center.x, tile_center.y, tile_center.z - get_tile_height())
			movement.move_direction.down:
				return Vector3(tile_center.x, tile_center.y, tile_center.z + get_tile_height())
			movement.move_direction.right:
				return Vector3(tile_center.x + get_tile_width(), tile_center.y, tile_center.z)
			movement.move_direction.left:
				return Vector3(tile_center.x - get_tile_width(), tile_center.y, tile_center.z)
			movement.move_direction.up_right:
				return Vector3(tile_center.x + get_tile_width(), tile_center.y, tile_center.z - get_tile_height())
			movement.move_direction.up_left:
				return Vector3(tile_center.x - get_tile_width(), tile_center.y, tile_center.z - get_tile_height())
			movement.move_direction.down_right:
				return Vector3(tile_center.x + get_tile_width(), tile_center.y, tile_center.z + get_tile_height())
			movement.move_direction.down_left:
				return Vector3(tile_center.x - get_tile_width(), tile_center.y, tile_center.z + get_tile_height())
