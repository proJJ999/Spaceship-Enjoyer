extends CharacterBody2D

var MAX_LIFE := 10
var BROKEN_THRESHHOLD := 5
var life: int

var target: Vector2
var move_angle: float
var MIN_MOVEMENT_DISTANCE := 20
var MAX_MOVEMENT_DISTANCE := 50
var SPEED := 5

var radiant_speed: float
var radiant_direction: int

@onready var player_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	anim_player.play("full_life")
	radiant_speed = PI / randi_range(4, 8)
	radiant_direction = 1 - 2 * randi_range(0, 1)
	target = position
	life = MAX_LIFE


func _on_damage_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("damage_source_interface"):
		var damage: int = body.get_damage()
		updateLife(damage)


func _physics_process(delta: float) -> void:
	if (position.distance_to(target) <= 40):
		target = calc_new_target()
		move_angle = position.angle_to_point(target)
	velocity = Vector2.RIGHT.rotated(move_angle) * SPEED
	move_and_slide()

	rotation += radiant_direction * radiant_speed * delta


func calc_new_target() -> Vector2:
	var target_x := randi_range(MIN_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE)
	target_x = target_x * (1 - 2 * randi_range(0, 1))
	var target_y := randi_range(MIN_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE)
	target_y = target_y * (1 - 2 * randi_range(0, 1))
	var relative_target := Vector2(target_x, target_y)
	relative_target = relative_target.rotated(randf_range(0, 2 * PI))
	return position + relative_target


func _on_area_entered(area):
	var damage = area.get_damage()
	updateLife(damage)


func updateLife(damage):
	life -= damage
	if (life <= BROKEN_THRESHHOLD):
		player_anim.play("broken")
	if (life <= 0):
		$CollisionShape2D.set_deferred("disabled", true)
		$DamageDetector.set_deferred("monitoring", false)
		player_anim.play("exploded")
		anim_player.play("die")
		self.set_physics_process(false)






