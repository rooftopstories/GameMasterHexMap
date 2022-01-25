extends ImmediateGeometry

var points = []

func addLine(p1:Vector3, p2:Vector3):
	points.append(p1)
	points.append(p2)

func _process(delta):
	# https://docs.godotengine.org/en/stable/tutorials/content/procedural_geometry/immediategeometry.html
	# https://godotengine.org/qa/2762/draw-line-in-3d
	#base._process(delta)
	# clean up before drawing
	clear()

	# begin draw
	begin(Mesh.PRIMITIVE_TRIANGLES)

	for point in points:
		add_vertex(point)

	# End drawing.
	end();
