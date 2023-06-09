extends CharacterBody2D

signal projectile_shot(parent, projectile)
signal player_took_damage(percentage_life)
signal player_died

@export var player_speed := 300
@export var radiant_speed := PI * 1.5
@export var projectile_scene : PackedScene

var cannon_switch := false
var is_on_cooldown := false

var MAX_LIFE := 5
var life := MAX_LIFE

@onready var player_anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	$AnimatedSprite2D.play("idle")


func _on_damage_detector_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("damage_source_interface"):
		var damage: int = area.owner.get_damage()
		updateLife(damage)


func _physics_process(delta: float) -> void:	
	rotation = calc_rotation(delta, rotation)
	velocity = calc_velocity(delta, velocity, player_speed)
	update_animation(velocity)
	move_and_slide()
	if(not is_on_cooldown):
		if(Input.is_action_pressed("shoot")):
			shoot()


func calc_rotation(delta: float, current_rotation: float) -> float:
	var output := current_rotation
	var direction := 0
	if(Input.is_action_pressed("left")):
		direction = -1
	if(Input.is_action_pressed("right")):
		direction = 1
	output += direction * radiant_speed * delta
	return output


func calc_velocity(delta: float, 
		current_velocity: Vector2,
		speed: float
	) -> Vector2:
	var direction := Vector2.ZERO
	if(Input.is_action_pressed("move_up")):
		direction += Vector2.UP
	if(Input.is_action_pressed("move_down")):
		direction += Vector2.DOWN
	if(Input.is_action_pressed("move_right")):
		direction += Vector2.RIGHT
	if(Input.is_action_pressed("move_left")):
		direction += Vector2.LEFT
	return direction * player_speed


func update_animation(velocity: Vector2) -> void:
	if(velocity.length() > 0):
		player_anim.play("flying")
	else:
		player_anim.play("idle")


func shoot() -> void:
	is_on_cooldown = true
	$ShootCooldown.start()
	
	var projectile: Variant = create_projectile()
	if projectile != null:
		projectile_shot.emit(self, projectile)
	
	await $ShootCooldown.timeout
	is_on_cooldown = false


func create_projectile() -> Variant:
	var projectile = projectile_scene.instantiate()
	
	if not projectile.is_in_group("projectile_interface"):
		return null
	
	projectile.init_player_projectile()
	
	var start: Vector2
	if(cannon_switch):
		start = $ProjectileSpawnLeft.global_position
	else:
		start = $ProjectileSpawnRight.global_position
	cannon_switch = not cannon_switch
	projectile.position = start
	projectile.rotation = rotation
	projectile.source_node = self
	projectile.apply_central_impulse(velocity * 0.2)
	
	return projectile


func updateLife(damage):
	life -= damage
	var percentage_life := float(life) / float(MAX_LIFE)
	player_took_damage.emit(percentage_life)
	if (life <= 0):
		$CollisionShape2D.set_deferred("disabled", true)
		player_died.emit()
		queue_free()
