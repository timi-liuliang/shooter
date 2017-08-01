extends KinematicBody2D

var cur_anim = ""

func _ready():
	play_anim("idle")

func play_anim(anim):
	if cur_anim != anim:
		get_node("anim").play(anim)
		cur_anim = anim