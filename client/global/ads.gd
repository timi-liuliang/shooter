extends Node

func _ready():
	if(Globals.has_singleton("Gomob")):
		var gomob = Globals.get_singleton("Gomob")
		gomob.init("ca-app-pub-9963645369065369/5009998113")
		gomob.set_test(true)
		gomob.connect("reward_based_videoad", self, "on_reward_ad", [])

func on_reward_ad(type, amount):
	print(type)
	print(amount)