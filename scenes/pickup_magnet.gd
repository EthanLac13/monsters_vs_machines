# This node automatically attracts pickups to the player
extends Node2D

var magnetized_objects: Array[Node2D] = []
var pickup_speed_min: float = 1.0
var pickup_speed_max: float = 4.0

func _process(delta: float) -> void:
	for i in range(magnetized_objects.size() - 1, -1, -1):
		var object = magnetized_objects[i]
		if object == null:
			magnetized_objects.remove_at(i)
		else:
			var distance_to_pickup: float = global_position.distance_to(object.global_position)
			var pickup_travel_speed: float = lerp(pickup_speed_max, pickup_speed_min, distance_to_pickup / 64.0)
			
			var move_vector = object.global_position.direction_to(global_position).normalized() * pickup_travel_speed
			object.position += move_vector
			
			if distance_to_pickup > 72.0:
				magnetized_objects.remove_at(i)

func _on_pickup_magnet_area_area_entered(area: Area2D) -> void:
	print(area)
	magnetized_objects.append(area.get_parent())
	pass # Replace with function body.
