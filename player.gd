extends Area2D

@export var player_speed = 600
@export var radiant_speed = PI * 1.5


func _ready():
	$AnimatedSprite2D.play("idle")

func _process(delta):
	var direction = 0
	if(Input.is_action_pressed("left")):
		direction = -1
	if(Input.is_action_pressed("right")):
		direction = 1

	rotation += direction * radiant_speed * delta

	if(Input.is_action_pressed("forward")):
		var velocity = Vector2.UP.rotated(rotation) * player_speed
		position += velocity * delta
		$AnimatedSprite2D.play("flying")
	else:
		$AnimatedSprite2D.play("idle")
