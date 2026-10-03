extends "res://scenes/characters/base_ai_controller.gd"

func initialize():
	super()
	# Don't display the mini health bar; we already have the full-length one on the GUI
	controlled_entity.get_node("HealthBar").visible = false

func _process(delta: float) -> void:
	super(delta)
			
