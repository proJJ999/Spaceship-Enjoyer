@tool
extends CharacterBody2D

signal projectile_shot(parent, projectile)

@export var player_speed := 300
@export var radiant_speed := PI * 1.5
@export var projectile_scene : PackedScene

var cannon_switch := false
var is_on_cooldown := false

@onready var player_anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	$AnimatedSprite2D.play("idle")

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
	
	var projectile = projectile_scene.instantiate()
	var start: Vector2
	if(cannon_switch):
		start = $ProjectileSpawnLeft.position
	else:
		start = $ProjectileSpawnRight.position
	cannon_switch = not cannon_switch
	projectile.position = start
	projectile.rotation = rotation
	projectile.source_node = self
	projectile.apply_central_impulse(velocity * 0.2)
	projectile_shot.emit(self, projectile)
	
	await $ShootCooldown.timeout
	is_on_cooldown = false


func _get_configuration_warnings() -> PackedStringArray:
	var errors: PackedStringArray = []
	if not projectile_scene:
		errors.append("A projecile scene has to be given")
	return errors

