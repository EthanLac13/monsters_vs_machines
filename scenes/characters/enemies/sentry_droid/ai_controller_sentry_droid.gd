extends "res://scenes/characters/base_ai_controller.gd"

var max_chase_dir: float = 16.0

func initialize():
	super()
	max_chase_dir = stats.max_chase_dir
	#controlled_entity.animation_object.change_animation("walk")

func _process(delta: float) -> void:
	super(delta)
	if controlled_entity != null:
		if controlled_entity.can_move:
			# Get player's position and move towards it
			var target_pos = target_entity.position
			
			# If we're farther than max_chase_dir range away from the target, get closer
			if controlled_entity.position.distance_to(target_pos) >= max_chase_dir:
				var movement_vector = controlled_entity.position.direction_to(target_pos).normalized()
				controlled_entity.move(movement_vector * movement_speed)
				
				# Change our direction based on movement
				var move_dir: float = rad_to_deg(movement_vector.angle())
				controlled_entity.animation_object.change_direction(move_dir)
