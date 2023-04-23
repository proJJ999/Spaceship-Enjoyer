extends Node

func _on_player_projectile_shot(parent, projectile) -> void:
	projectile.position = projectile.position.rotated(parent.rotation) + parent.global_position
	add_child(projectile)
