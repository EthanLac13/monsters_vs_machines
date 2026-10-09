extends Node2D

func attempt_interact():
	for area in $InteractionArea.get_overlapping_areas():
		area.get_parent().interact()

func _on_interaction_area_area_entered(area: Area2D) -> void:
	area.get_parent().set_interactable()

func _on_interaction_area_area_exited(area: Area2D) -> void:
	area.get_parent().set_not_interactable()
