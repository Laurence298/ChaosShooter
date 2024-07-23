extends Control


@onready var heatdeath = $CombustText
@onready var gundeath = $GunText
@onready var dogdeath = $DogText

func _on_heat_death():
	heatdeath.show()
	
func _on_gun_death():
	gundeath.show()	
	
func _on_dog_death():
	dogdeath.show()

func _on_try_again_button_pressed():
	get_tree().quit() # Replace with wawaaaaaaaaaaaaafunction body.

	pass # Replace with function body.

