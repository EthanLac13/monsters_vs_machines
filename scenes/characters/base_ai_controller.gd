extends Node2D

var controlled_entity: Node2D

func _process(delta: float) -> void:
	if controlled_entity == null:
		queue_free()
