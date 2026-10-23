extends "res://scenes/characters/base_ai_controller.gd"

var max_chase_dir: float = 16.0

func initialize():
	super()

func _process(delta: float) -> void:
	super(delta)
	if controlled_entity != null:
		if controlled_entity.can_move && !controlled_entity.using_skill && !controlled_entity.is_flinching:
			
			# Decide whether to chase the player or follow the track
			var target_pos = get_target_pos()
			
			# If we're farther than max_chase_dir range away from the target, get closer
			if controlled_entity.position.distance_to(target_pos) >= max_chase_dir:
				var movement_vector = controlled_entity.position.direction_to(target_pos).normalized()
				var movement_speed = controlled_entity.get_effective_move_speed()
				controlled_entity.move(movement_vector * movement_speed)
				
				# Change our direction based on movement
				var move_dir: float = rad_to_deg(movement_vector.angle())
				controlled_entity.move_dir = move_dir
				controlled_entity.animation_object.change_direction(move_dir)
