extends Node3D

@onready var drag_manager = %DragManager
@onready var game_manager = %GameManager
@onready var spawn_manager = %SpawnManager
@onready var ui_manager = %UIManager
@onready var merge_platform = %MergePlatform

var mergeables = []
var mergedCount : int


func OnMergeableEnterMergeArea(body):
	if mergeables.size() >= 2:
		return
	if mergeables.has(body):
		return
	mergeables.push_back(body)
	
	drag_manager.StopDrag()
	body.freeze = true
	
	var tween = create_tween()
#	tween.tween_property(body, "position", merge_platform.get_node("MergePlatform").get("platforms[mergeables.size() - 1]").position, 1.0)
#	var mergePlatform = $MergePlatform
	var newPos = merge_platform.platforms[mergeables.size() - 1].global_position
	newPos.y += 1.0
	tween.tween_property(body, "position", newPos, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(body, "rotation", Vector3.ZERO, 0.5)
	var onTweenEnd = func OnTweenEnd():
		CheckMerge()
	tween.tween_callback(onTweenEnd)

func OnMergeableExitMergeArea(body):
	var id = mergeables.find(body)
	if id == -1:
		return
	mergeables.remove_at(id)
	body.freeze = false


func CheckMerge():
	if(CheckIds() == false and mergeables.size() != 2):
		return
	if(CheckIds() == false):
		var secondObject = mergeables[1]
		mergeables.remove_at(1)
		secondObject.SendMeToCenter()
		return
		
	mergedCount += 1
	var animTime = 0.25
	var tempMergeables = mergeables.duplicate()
	mergeables.clear()
	
	for item in tempMergeables:
		var tween = create_tween()
		tween.tween_property(item, "position", merge_platform.global_position, animTime)
#		tween.tween_callback()

	await get_tree().create_timer(animTime).timeout
	ui_manager.IncreaseStarText(1)
	if mergedCount >= spawn_manager.spawnCount:
		game_manager.LevelCompleted()
	
	for item in tempMergeables:
		var tween = create_tween()
		var newPos = merge_platform.global_position
		newPos.y -= 3.0
		tween.tween_property(item, "position", newPos, animTime * 2)
		var lastCallback = func LastCallback():
			item.queue_free()
		tween.tween_callback(lastCallback)

func CheckIds() -> bool:
	if mergeables.size() != 2:
		return false
	var firstId = mergeables[0].myId
	var secondId = mergeables[1].myId
	if firstId == secondId:
		print("IDler ayni.")
		return true
	else:
		print("IDler farkli.")
		return false
