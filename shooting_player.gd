extends Node2D

@export var bullet_scene : PackedScene
var cannon_switch = false
var is_on_cooldown = false

func _process(delta):
	if(not is_on_cooldown):
		if(Input.is_action_pressed("shoot")):
			shoot()

func shoot():
	is_on_cooldown = true
	$BulletCooldown.start()
	
	var bullet = bullet_scene.instantiate()
	var start = $Player.position
	var player_rotation = $Player.rotation
	if(cannon_switch):
		start += $BulletSpawnLeft.position.rotated(player_rotation)
	else:
		start += $BulletSpawnRight.position.rotated(player_rotation)
	cannon_switch = not cannon_switch
	bullet.position = start
	bullet.rotation = player_rotation
	add_child(bullet)

func _on_bullet_cooldown_timeout():
	is_on_cooldown = false
