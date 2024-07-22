extends Node

const BULLET = preload("res://scenes/bullet.tscn")

enum CollisionLayer{PLAYER = 1, ENEMY = 2}

func create_bullet(shooter, collision_layer, velocity, offset, position, playerstats: Player_Status):
	
	var nbullet = BULLET.instantiate()
	nbullet.shooter = shooter
	nbullet.set_collision_mask_value(collision_layer, true)
	nbullet.position = position + velocity.normalized()*offset
	nbullet.velocity = velocity
	nbullet.damage = playerstats.damage
	nbullet.transform.scaled(playerstats.bullet_size)
	get_tree().root.add_child(nbullet)
	
	return nbullet
	
func create_bulletAi(shooter, collision_layer, velocity, offset, position):
	
	var nbullet = BULLET.instantiate()
	nbullet.shooter = shooter
	nbullet.set_collision_mask_value(collision_layer, true)
	nbullet.position = position + velocity.normalized()*offset
	nbullet.velocity = velocity
	nbullet.damage = 5

	get_tree().root.add_child(nbullet)
	
	return nbullet
func shotgun(shooter, collision_layer, velocity, num, spread, speed_vary, slow_down, playerstats: Player_Status):
	for i in range(num):
		var rand = randi_range(-spread,spread)
		var rand_speed = randi_range(2 * speed_vary, speed_vary)
		var speed_diff:float = 1.0 - rand_speed/velocity.length()
		
		var nbullet = create_bullet(shooter, collision_layer, velocity.rotated(deg_to_rad(rand)) * speed_diff, 25, shooter.global_position, playerstats)
