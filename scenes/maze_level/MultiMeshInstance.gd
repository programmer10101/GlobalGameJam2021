extends MultiMeshInstance

var cube_size
var collisionNode

func init(arr, size):
    collisionNode = StaticBody.new()
    cube_size = size
    self.add_child(collisionNode)
    cube_size = 1
    setup_multimesh(arr.size())
    generate_cubes(arr)

func generate_cubes(arr):
    for i in range(arr.size()):
        generate_cube(arr[i], i)

func generate_cube(loc, i):
    var pos = Vector3(loc.x * cube_size, cube_size / 2.0, loc.y * cube_size)
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
