extends Node

var curScene = null

func _ready():
	var nodeIdx = get_tree().get_root().get_child_count()-1
	curScene = get_tree().get_root().get_child(nodeIdx)

# switch to scene by name
func setScene(name):
	if curScene:
		curScene.queue_free()
		
	var sceneRes = ResourceLoader.load(name)
	curScene = sceneRes.instance()
	get_tree().get_root().add_child(curScene)
	
