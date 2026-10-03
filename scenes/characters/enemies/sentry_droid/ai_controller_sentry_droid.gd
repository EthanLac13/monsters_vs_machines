extends "res://scenes/characters/base_ai_controller.gd"

var max_chase_dir: float = 16.0

var hitbox_scene = load("res://scenes/skills/enemies/sentry_droid/SentryDroidAttack.tscn")
var attack_node
var attack_hitbox

func initialize():
	super()
	max_chase_dir = stats.max_chase_dir
	crystal_chase_dir = stats.crystal_chase_dir
	
	controlled_entity.skill_list.append("res://scenes/skills/enemies/sentry_droid/SentryDroidAttack.tscn")
	#controlled_entity.animation_object.change_animation("walk")

func _process(delta: float) -> void:
	super(delta)
	if controlled_entity != null:
		if controlled_entity.can_move && !controlled_entity.using_skill && !controlled_entity.is_flinching:
			
			# Decide whether to chase the player or follow the track
			var target_pos = get_target_pos()
			
			# If we're farther than max_chase_dir range away from the target, get closer
			if controlled_entity.position.distance_to(target_pos) >= max_chase_dir:
				var movement_vector = controlled_entity.position.direction_to(target_pos).normalized()
				controlled_entity.move(movement_vector * movement_speed)
				
				# Change our direction based on movement
				var move_dir: float = rad_to_deg(movement_vector.angle())
				controlled_entity.move_dir = move_dir
				controlled_entity.animation_object.change_direction(move_dir)
			else:
				attack()

func attack():
	if !controlled_entity.using_skill:
		# Create the attack object
		attack_node = hitbox_scene.instantiate()
		attack_node.state = 1
		controlled_entity.add_child(attack_node)
		controlled_entity.current_skill_scene = attack_node
		controlled_entity.using_skill = true
		controlled_entity.animation_object.change_animation("attack", controlled_entity.move_dir)
