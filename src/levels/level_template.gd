extends Node

@onready var hud: Control = $Hud

func _on_projectile_shot(parent, projectile) -> void:
	add_child(projectile)


func _on_player_player_took_damage(percentage_life) -> void:
	hud.update_lifebar(percentage_life)


func _on_player_player_died() -> void:
	get_tree().paused = false
	hud.activate_play_again()


func _on_hud_play_again() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
