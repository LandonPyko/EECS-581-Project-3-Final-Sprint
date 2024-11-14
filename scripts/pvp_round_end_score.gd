extends Label


func _process(delta):
	self.text = "P1 Score: " + str(Global.p1_score) + " P2 Score: " + str(Global.p2_score)
