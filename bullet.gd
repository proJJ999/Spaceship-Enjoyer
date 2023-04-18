extends Area2D

@export var speed = 40000
var damage = 1
var source_node : Node

func _process(delta):
	var velocity = Vector2.UP.rotated(rotation) * speed * delta
	position += velocity * delta

func get_damage():
	return damage


func despawn(area):
	if (area != source_node):
		queue_free()
