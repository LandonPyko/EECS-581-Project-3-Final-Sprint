extends Label

func _process(delta):
	self.text = "Round Score: " + str(Global.temp_score)
