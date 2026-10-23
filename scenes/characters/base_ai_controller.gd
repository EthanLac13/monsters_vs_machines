extends Node2D

var controlled_entity: Node2D
var target_entity: Node2D
var player_entity: Node2D

var stats

var crystal_chase_dir: float = 128.0
var next_node_dir: float = 24.0

func initialize():
	player_entity = get_tree().get_nodes_in_group("friendly_characters")[0]
	
	# Get stats from stats holder
	stats = controlled_entity.animation_object.anim_object
	
	# Set the controlled entity's stats
	controlled_entity.stats_data.hp = stats.health
	controlled_entity.stats_data.max_hp = stats.health
	
	controlled_entity.stats_data.base_stats.attack = stats.attack
	controlled_entity.stats_data.base_stats.defense = stats.defense
	controlled_entity.stats_data.base_stats.magic_attack = stats.magic_attack
	controlled_entity.stats_data.base_stats.magic_defense = stats.magic_defense
	
	controlled_entity.move_speed = stats.movement_speed
	
	controlled_entity.can_flinch = stats.can_flinch
	controlled_entity.weight = stats.weight
	
	# Enemy has no mercy by default
	controlled_entity.mercy_timer_max = 0
	
	# Set enemy's collision
	if controlled_entity.faction == 1:
		controlled_entity.wall_collider.collision_mask = 513
		controlled_entity.collision_blocker.collision_layer = 256

func _process(delta: float) -> void:
	if controlled_entity == null:
		queue_free()
