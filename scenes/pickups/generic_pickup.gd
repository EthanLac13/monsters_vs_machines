extends Node2D

@export var collision_shapecast: ShapeCast2D

func _process(delta: float) -> void:
	collision_shapecast.force_shapecast_update()
	if collision_shapecast.is_colliding():
		player_touched(collision_shapecast.get_collider(0))

func player_touched(collider: Area2D):
	print(collider)
	queue_free()
