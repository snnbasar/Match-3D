extends Node3D

var MergeManager
var canMove = true
@export var isDragging = false
@export var lerpSpeed := 5.0
@export var yOffset := 1.0
var draggedObject = null
var hoveredObject = null
var offset : Vector3

func _ready():
	MergeManager = %MergeManager


func _process(delta):
	if canMove == false:
		return
		
	if Input.is_action_just_pressed("click"):
		StartDrag()
		
	if Input.is_action_just_released("click"):
		StopDrag()
	
	if draggedObject == null:
		return
	if Input.is_action_pressed("click"):
		var newPos = ScreenPointToRay()
		newPos.y = offset.y
#		draggedObject.position = newPos
#		var dir : Vector3 = newPos - draggedObject.position
#		dir = dir.normalized()
#		draggedObject.apply_torque(dir * 5)
		draggedObject.targetPos = newPos




func ScreenPointToRay():
	var spaceState = get_world_3d().direct_space_state
	
	var mousePos = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
#	var rayArray  = spaceState.intersect_ray(rayOrigin, rayEnd)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = rayOrigin
	params.to = rayEnd
	params.exclude = []

	params.collision_mask = 1
	var rayArray = spaceState.intersect_ray(params)
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3()


func StartDrag():
	if hoveredObject == null:
		return
	draggedObject = hoveredObject
	var newPos = ScreenPointToRay()
	offset = newPos
	offset.y = yOffset
	isDragging = true
	draggedObject.OnDragStart()
	
func StopDrag():
	if draggedObject != null:
		draggedObject.OnDragEnd()
	isDragging = false
	draggedObject = null

func SetHovered(hovered):
	hoveredObject = hovered
