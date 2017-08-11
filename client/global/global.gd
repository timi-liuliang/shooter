extends Node

var curScene = null

func _ready():
	var nodeIdx = 0#get_tree().get_root().get_child_count()-1
	curScene = get_tree().get_root().get_child(nodeIdx)
	
	# 加载全局脚本
	load_global_scripts()

# switch to scene by name
func set_scene(name):
	if curScene:
		curScene.queue_free()
		
	var sceneRes = ResourceLoader.load(name)
	curScene = sceneRes.instance()
	get_tree().get_root().add_child(curScene)
	
# 启动
func load_global_scripts():
	var data = preload("res://global/data.gd").new()
	data.set_name("data")
	get_tree().get_root().add_child(data)
	
	var wechat = preload("res://global/wechat.gd").new()
	wechat.set_name("wechat")
	get_tree().get_root().add_child(wechat)
	
	var ads = preload("res://global/ads.gd").new()
	ads.set_name("ads")
	get_tree().get_root().add_child(ads)
	
