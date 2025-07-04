extends Area2D

@export var firerate : float 
@export var recoil = 0
@export var bullet_size : Vector2
@export var damage = 0
@export var power_up: PowerUp.body_modification
@export var weapon_Type: PowerUp.WeaponType


func _on_body_entered(body):
	if body.is_in_group("player"):
		var updated_status = Player_Status.new()
		updated_status.bullet_size = bullet_size
		updated_status.enemyKnockBackStreangth = recoil
		updated_status.damage = damage
		updated_status.firerate = firerate
		updated_status.KnockBackStreagth = recoil
		updated_status.body_modification = power_up
		updated_status.weapon_Type = weapon_Type
		body.set_combatStatus(updated_status)
		queue_free()
