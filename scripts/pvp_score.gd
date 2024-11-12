extends Label

func _process(delta):
	self.text = "Player 1 Score: " + str(Global.p1_score) + "\nPlayer 2 Score: " + str(Global.p2_score)
