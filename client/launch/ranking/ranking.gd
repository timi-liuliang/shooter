extends Control

func _ready():
	pass
	
func refresh_display(dict):
	var boxContainer = get_node("ranking/ScrollContainer/VBoxContainer")
	for child in boxContainer.get_children():
		child.queue_free()
	
	var size = dict.data.size()
	for item in dict.data:
		var account = item.account
		var name = item.name
		var score = item.score
		
		var item = preload("res://launch/ranking/item.tscn").instance()
		item.set(account, name, score)
		boxContainer.add_child(item)
		
