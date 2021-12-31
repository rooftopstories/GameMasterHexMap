extends Spatial

var hex_tile

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
			hexes.append(hex)

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

func get_camera():
	return $main_camera
