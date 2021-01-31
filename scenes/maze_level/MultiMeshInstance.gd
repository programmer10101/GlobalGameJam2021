extends MultiMeshInstance

var cube_size = 1
var y_origin = cube_size / 2.0
var collisionNode = StaticBody.new()

func init(arr):
	self.add_child(collisionNode)
	setup_multimesh(arr.size())
	generate_cubes(arr)

func generate_cubes(arr):
	print(arr)
	var offset = findOffset(arr)
	print(offset)
	for i in range(arr.size()):
		generate_cube(arr[i], i, offset)
	
func findOffset(arr):
	var minXY = arr[0]
	var maxXY = arr[0]
	for i in arr:
		minXY.x = min(i.x, minXY.x)
		minXY.y = min(i.y, minXY.y)
		maxXY.x = max(i.x, maxXY.x)
		maxXY.y = max(i.y, maxXY.y)
	return Vector2((maxXY.x - minXY.x) * cube_size / 2.0, (maxXY.y - minXY.y) * cube_size / 2.0)

func generate_cube(loc, i, offset):
	var pos = Vector3(loc.x * cube_size - offset.x, y_origin, loc.y * cube_size - offset.y)
	var transform = Transform(Basis(), pos)
	self.multimesh.set_instance_transform(i, Transform(Basis(), pos))
	var collisionShape = CollisionShape.new()
	var mesh = CubeMesh.new()
	mesh.size = Vector3(1,1,1)
	collisionShape.shape = mesh
	collisionShape.transform = transform
	collisionNode.add_child(collisionShape)

func setup_multimesh(instances):
	self.multimesh = MultiMesh.new()
	self.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	self.multimesh.instance_count = instances
	self.multimesh.visible_instance_count = self.multimesh.instance_count
	var mesh = CubeMesh.new()
	mesh.size = Vector3(1,1,1)
	self.multimesh.mesh = mesh
