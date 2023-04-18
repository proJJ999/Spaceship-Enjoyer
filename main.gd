extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_bullet_shot(parent, bullet):
	bullet.position = bullet.position.rotated(parent.rotation) + parent.global_position
	add_child(bullet)
