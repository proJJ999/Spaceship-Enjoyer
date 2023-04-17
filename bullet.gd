extends Area2D

@export var speed = 100000

func _process(delta):
	var velocity = Vector2.UP.rotated(rotation) * speed * delta
	position += velocity * delta
	
