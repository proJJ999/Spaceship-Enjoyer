extends Node

func _on_projectile_shot(parent, projectile) -> void:
	add_child(projectile)
