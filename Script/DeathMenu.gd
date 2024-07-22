extends Control


@onready var heatdeath = $CombustText
@onready var gundeath = $GunText
@onready var dogdeath = $DogText

func _on_heat_death():
	heatdeath.show = true
	
func _on_gun_death():
	gundeath.show = true	
	
func _on_dog_death():
	dogdeath.hide()	

func _on_try_again_button_pressed():
	get_tree().change_scene_to_file("res://Scenes//PlaceHolder.tscn") # Replace with function body.
	pass # Replace with function body.
