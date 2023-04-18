extends Area2D

var life = 10
var BROKEN_THRESHHOLD = 5

var target : Vector2
var move_angle : float
var MIN_MOVEMENT_DISTANCE = 20
var MAX_MOVEMENT_DISTANCE = 50
var SPEED = 5

var radiant_speed : float
var radiant_direction : int

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("full_life")
	radiant_speed = PI / randi_range(4, 8)
	radiant_direction = 1 - 2 * randi_range(0, 1)
	target = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (position.distance_to(target) <= 40):
		target = calc_new_target()
		move_angle = position.angle_to_point(target)
	var velocity = Vector2.RIGHT.rotated(move_angle) * SPEED
	position += velocity * delta

	rotation += radiant_direction * radiant_speed * delta

func calc_new_target():
	var target_x = randi_range(MIN_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE)
	target_x = target_x * (1 - 2 * randi_range(0, 1))
	var target_y = randi_range(MIN_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE)
	target_y = target_y * (1 - 2 * randi_range(0, 1))
	var relative_target = Vector2(target_x, target_y)
	relative_target = relative_target.rotated(randf_range(0, 2 * PI))
	return position + relative_target

func _on_area_entered(area):
	var damage = area.get_damage()
	updateLife(damage)


func updateLife(damage):
	life -= damage
	if (life <= BROKEN_THRESHHOLD):
		$AnimatedSprite2D.play("broken")
	if (life <= 0):
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("exploded")
		$AnimationPlayer.play("die")
		self.set_process(false)
		await $AnimationPlayer.animation_finished
		queue_free()
