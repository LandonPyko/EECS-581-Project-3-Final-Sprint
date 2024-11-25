extends Label


func _process(delta):
	self.text = "Player 1 Score: " + str(Global.p1_score) + ", Player 2 Score: " + str(Global.p2_score)
