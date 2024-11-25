extends Label

func _process(_delta):
	self.text = "Round Score: " + str(Global.score)
