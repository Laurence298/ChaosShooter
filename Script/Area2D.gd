extends Area2D

func _on_area_2d_body_entered(body):
	pass # Replace with function body.



func _on_body_entered(body):
	if body.is_in_group("player") :
		body.randomize_upgrades()
		print("changing guns")
