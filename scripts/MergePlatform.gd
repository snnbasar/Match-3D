extends Area3D

var platforms = []
var MergeManager
# Called when the node enters the scene tree for the first time.
func _ready():
	MergeManager = %MergeManager
#		pass
	for child in self.get_children():
		if child is MeshInstance3D:
			platforms.append(child)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#	func _on_body_entered(body):
#		if body.is_in_group("mergeable"):
#			print("mergeable found")
#			MergeManager.OnMergeableEnterMergeArea(body)


func _on_body_entered(body):
	if body.is_in_group("mergeable"):
		print("mergeable found")
		MergeManager.OnMergeableEnterMergeArea(body)


func _on_body_exited(body):
	if body.is_in_group("mergeable"):
		print("mergeable exited")
		MergeManager.OnMergeableExitMergeArea(body)
