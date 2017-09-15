extends TextureFrame

func set(idx, name, score):
	get_node("idx").set_text(String(idx))
	get_node("name").set_text(String(name))
	get_node("score").set_text(String(score))
