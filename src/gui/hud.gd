extends Control

signal play_again

@onready var play_again_button: Button = $PlayAgainButton
@onready var lifebar: TextureProgressBar = $Lifebar

func _ready() -> void:
	play_again_button.visible = false
	play_again_button.disabled = true


func _on_play_again_button_up() -> void:
	play_again.emit()


func activate_play_again() -> void:
	play_again_button.visible = true
	play_again_button.disabled = false
	pass

func update_lifebar(percentage: float) -> void:
	var new_value: int = roundi(percentage * float(lifebar.max_value))
	lifebar.value = new_value
