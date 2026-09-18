extends Node2D

var controlled_entity: Node2D
var target_entity: Node2D

func initialize():
	target_entity = get_parent().get_parent().get_node("Player")

func _process(delta: float) -> void:
	if controlled_entity == null:
		queue_free()
