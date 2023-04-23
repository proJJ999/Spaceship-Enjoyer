extends RigidBody2D

var MAX_LIFE := 5
var life: int

var radiant_speed: float
var radiant_direction: int

var damage := 20

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _init() -> void:
	add_to_group("damage_source_interface")
	radiant_speed = PI / randi_range(4, 8)
	radiant_direction = 1 - 2 * randi_range(0, 1)
	life = MAX_LIFE


func _ready() -> void:
	pass


func _on_damage_detector_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("damage_source_interface"):
		var damage: int = area.owner.get_damage()
		updateLife(damage)


func _physics_process(delta: float) -> void:
	rotation += radiant_direction * radiant_speed * delta


func updateLife(damage):
	life -= damage
	if (life <= 0):
		$CollisionShape2D.set_deferred("disabled", true)
		$DamageDetector.set_deferred("monitoring", false)
		$DamageArea.set_deferred("monitorable", true)
		anim_player.play("explode")
		self.set_physics_process(false)


func get_damage() -> int:
	return damage


