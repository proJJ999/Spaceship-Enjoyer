extends RigidBody2D

@export var speed := 300

var damage := 1
var source_node : Node


func _init() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	add_to_group("damage_source_interface")
	add_to_group("projectile_interface")


func _ready() -> void:
	var impuls = Vector2.UP.rotated(rotation) * speed
	apply_central_impulse(impuls)


func _on_body_entered(body: Node) -> void:
	contact_monitor = false
	max_contacts_reported = 0
	await get_tree().create_timer(0.05).timeout
	queue_free()


func get_damage() -> int:
	return damage

func init_player_projectile() -> void:
	var player_mask := 0b0001
	var enemy_mask := 0b1010
	var entity_mask := 0b0100
	var terrain_mask := 0b1000
	collision_layer = player_mask
	collision_mask = enemy_mask | entity_mask | terrain_mask
	var damage_area: Area2D = $DamageArea
	damage_area.collision_layer = player_mask
	damage_area.collision_mask = enemy_mask | entity_mask

func init_enemy_projectile() -> void:
	var player_mask := 0b0001
	var enemy_mask := 0b0010
	var entity_mask := 0b0100
	var terrain_mask := 0b1000
	collision_layer = enemy_mask
	collision_mask = player_mask | entity_mask | terrain_mask
	var damage_area: Area2D = $DamageArea
	damage_area.collision_layer = enemy_mask
	damage_area.collision_mask = player_mask
