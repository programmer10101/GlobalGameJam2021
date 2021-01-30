extends MultiMeshInstance

var locs = [Vector2(1, 1), Vector2(1, 2), Vector2(1,3), Vector2(1,4), Vector2(2,4)]
var instances = locs.size()
var cube_size = 1
var y_origin = cube_size / 2.0

func _ready():
	setup_multimesh(instances)
	generate_cubes()
	
func generate_cubes():
	print(locs)
	for i in range(locs.size()):
		generate_cube(locs[i], i)
	
func generate_cube(loc, i):
	var pos = Vector3(loc.x * cube_size, y_origin, loc.y * cube_size)
	self.multimesh.set_instance_transform(i, Transform(Basis(), pos))

func setup_multimesh(instances):
	self.multimesh = MultiMesh.new()
	self.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	self.multimesh.instance_count = instances
	self.multimesh.visible_instance_count = self.multimesh.instance_count
	var mesh = CubeMesh.new()
	mesh.size = Vector3(1,1,1)
	self.multimesh.mesh = mesh
