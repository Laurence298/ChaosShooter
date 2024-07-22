extends Control


@onready var heatdeath = $CombustText
@onready var gundeath = $GunText
@onready var dogdeath = $DogText

func _on_heat_death():
<<<<<<< Updated upstream
	heatdeath.hide()	
	
func _on_gun_death():
	gundeath.hide()	
=======
	heatdeath.show()
	
func _on_gun_death():
	gundeath.show()	
>>>>>>> Stashed changes
	
func _on_dog_death():
	dogdeath.show()

func _on_try_again_button_pressed():
	get_tree().change_scene_to_file("res://Scenes//main.tscn") # Replace with function body.
	pass # Replace with function body.
