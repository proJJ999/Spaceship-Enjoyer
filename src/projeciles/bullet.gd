extends RigidBody2D

@export var speed := 300

var damage := 1
var source_node : Node


func _init() -> void:
	contact_monitor = true
	max_contacts_reported = 1


func _ready() -> void:
	add_to_group("damage_source_interface")
	var impuls = Vector2.UP.rotated(rotation) * speed
	apply_central_impulse(impuls)


func _on_body_entered(body: Node) -> void:
	contact_monitor = false
	max_contacts_reported = 0
	await get_tree().create_timer(0.05).timeout
	queue_free()


func get_damage() -> int:
	return damage

