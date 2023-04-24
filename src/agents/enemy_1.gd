extends RigidBody2D

signal projectile_shot(parent, projectile)

@export var projectile_scene : PackedScene

var MAX_LIFE := 5
var life: int
var is_on_cooldown := false

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _init() -> void:
	life = MAX_LIFE


func _on_damage_detector_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("damage_source_interface"):
		var damage: int = area.owner.get_damage()
		updateLife(damage)


func _physics_process(delta: float) -> void:
	if(not is_on_cooldown):
		shoot()


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
	
	projectile.init_enemy_projectile()
	projectile.position = global_position
	projectile.rotation = randf_range(0.0, 2.0 * PI)
	projectile.source_node = self
	
	return projectile


func updateLife(damage):
	life -= damage
	if (life <= 0):
		$CollisionShape2D.set_deferred("disabled", true)
		$DamageDetector.set_deferred("monitoring", false)
		anim_player.play("die")
		self.set_physics_process(false)
