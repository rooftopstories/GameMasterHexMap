extends Spatial

var hex_tile

var node_player

export var editor_mode:bool=false
export var pack:bool=false
export var scroll_edges:bool=true

export var grid_w:int=20
export var grid_h:int=20

var tile_w:float=1.73205
var tile_h:float=2.0

var start_pos = Vector3(0,0,0)

var hexes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hex_tile = preload("res://world/hexes/HexTile.res")

	for x in range(grid_w):
		for y in range (grid_h):
			var hex = hex_tile.instance()
			var grid_pos = Vector2(x,y)
			hex.set_name(str(x) + "|" + str(y))
			add_child(hex)
			hex.set_owner(self)
			var hex_pos = calc_world_pos(grid_pos)
			hex.set_translation(hex_pos)
			hex.editor_mode = editor_mode
			hexes.append(hex)
	
	if pack:
		var packed_scene = PackedScene.new()
		packed_scene.pack(get_tree().get_current_scene())
		"""
		Accepted Endings
		# Returns: scn, res, xml, xscn, tscn
		ResourceSaver.get_recognized_extensions(packed_scene)
		"""
		ResourceSaver.save("res://new_map.tscn", packed_scene)
		
		"""
		To Load with code:
		# Load the PackedScene resource
		var packed_scene = load("res://my_scene.tscn")
		# Instance the scene
		var my_scene = packed_scene.instance()
		add_child(my_scene)
		"""

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"grid_w" : grid_w,
		"grid_h" : grid_h,
		"hexes" : {
			
		}
	}
	
	for hex in hexes:
		save_dict['hexes'][hex.name] = []
		for child in hex.get_children():
			if 'triggers' in child:
				save_dict['hexes'][hex.name].append(
					{
						'object_path': child.filename,
						'triggers': child.triggers 
					}
				)
			elif 'player' in child:
				save_dict['hexes'][hex.name].append(
					{
						'object_path': child.filename,
						'player': true
					}
				)
	
	return save_dict

func _save(path):
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene().current_map)
	"""
	Accepted Endings
	# Returns: scn, res, xml, xscn, tscn
	ResourceSaver.get_recognized_extensions(packed_scene)
	"""
	ResourceSaver.save(path, packed_scene)
	
	"""
	To Load with code:
	# Load the PackedScene resource
	var packed_scene = load("res://my_scene.tscn")
	# Instance the scene
	var my_scene = packed_scene.instance()
	add_child(my_scene)
	"""

func calc_world_pos(var grid_pos : Vector2):
	var offset = 0.0 
	if int(grid_pos.y) % 2 != 0:
		offset = tile_w/2
		grid_w -= 1
	else:
		grid_w += 1
	
	var x = start_pos.x + grid_pos.x * tile_w + offset
	var z = start_pos.z - grid_pos.y * tile_h * 0.75
	var y = 0
	
	return (Vector3(x, y, z))

func get_editor():
	if editor_mode:
		return get_parent()

func live_mode(active:bool):
	if active:
		editor_mode = false
		pack = false
		scroll_edges = true
		
		for hex in hexes:
			hex.editor_mode = false
	else:
		editor_mode = true
		pack = false
		scroll_edges = false
		
		for hex in hexes:
			hex.editor_mode = true

func get_camera():
	return $main_camera
