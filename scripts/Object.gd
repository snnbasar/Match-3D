extends RigidBody3D

#@onready var drag_manager = $"../DragManager"
var draggable = false
var targetPos : Vector3
var varAlph = 0.0
var DragManager
@export var myId : int = 0

var scaleTween : Tween
# Called when the node enters the scene tree for the first time.
func _ready():
#	DragManager = %DragManager
	DragManager = get_node("../DragManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#	if draggable == true:
#		if Input.is_action_just_pressed("click"):
#			DragManager.StartDrag(self)

func _physics_process(delta):
	if draggable == false:
		return
	global_position = global_position.lerp(targetPos, DragManager.lerpSpeed * delta)

func _on_mouse_entered():
	DragManager.SetHovered(self)
#	print("mouse entered")

func _on_mouse_exited():
#	if DragManager.GetDraggable() == self:
	DragManager.SetHovered(null)
#	print("mouse exited")

func OnDragStart():
	draggable = true
	gravity_scale = 0
	if freeze == true:
		freeze = false
	DoScaleAnim()

func OnDragEnd():
	draggable = false
	gravity_scale = 1
#	DoScaleAnim()

func SendMeToCenter():
	freeze = false
	var dir := Vector3.UP * 9.0 - global_position
	dir = dir.normalized()
	self.apply_central_impulse(dir * 8.0)

func DoScaleAnim():
	if scaleTween != null and scaleTween.is_running():
		scaleTween.kill()
	var animTime = 0.25
	scaleTween = create_tween()
	scaleTween.tween_property(self, "scale", Vector3.ONE * 1.2, animTime / 2)
	await get_tree().create_timer(animTime / 2).timeout
	scaleTween = create_tween()
	scaleTween.tween_property(self, "scale", Vector3.ONE, animTime / 2)
