extends Node3D

@export var prefabs : Array[PackedScene]
@export var spawnCount : int
@export var spawnPoses : Array[Node3D]
@onready var game_manager = %GameManager

var rng = RandomNumberGenerator.new()

func _ready():
	spawnCount = getRandomNumber(16, 10)
	game_manager.SetGameTime(spawnCount * game_manager.gameTimeForOneMerge)
	SpawnInstances()

func SpawnInstances():
	for i in spawnCount:
		var prefabToSpawn = prefabs[getRandomNumber(prefabs.size() - 1)]
		for a in 2:
			var newInstance = prefabToSpawn.instantiate()
			$"..".add_child.call_deferred(newInstance)
			var newPos = Vector3.ZERO
			newPos.x = getRandomFloat(spawnPoses[0].global_position.x, spawnPoses[1].global_position.x)
			newPos.y = getRandomFloat(spawnPoses[0].global_position.y, spawnPoses[1].global_position.y)
			newPos.z = getRandomFloat(spawnPoses[0].global_position.z, spawnPoses[1].global_position.z)
			newInstance.position = newPos

func getRandomNumber(max : int, min := 0):
	var my_random_number = rng.randi_range(min, max)
	return my_random_number

func getRandomFloat(min : float, max : float) -> float:
	var my_random_number = rng.randf_range(min, max)
	return my_random_number
