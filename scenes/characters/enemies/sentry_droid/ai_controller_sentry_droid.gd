extends "res://scenes/characters/base_ai_controller.gd"

func _process(delta: float) -> void:
	super(delta)
	if controlled_entity != null:
		controlled_entity.input_right = true
