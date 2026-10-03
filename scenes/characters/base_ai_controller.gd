extends Node2D

var controlled_entity: Node2D
var target_entity: Node2D
var player_entity: Node2D
var target_crystal_entity: Node2D

var stats

var movement_speed: float = 0.0

func initialize():
	player_entity = get_parent().get_node("Player")
	target_crystal_entity = get_parent().get_node("TargetCrystal")
	target_entity = player_entity
	
	# Get stats from stats holder
	stats = controlled_entity.animation_object.anim_object
	
	# Set the controlled entity's stats
	controlled_entity.stats_data.hp = stats.health
	controlled_entity.stats_data.max_hp = stats.health
	
	controlled_entity.stats_data.base_stats.attack = stats.attack
	controlled_entity.stats_data.base_stats.defense = stats.defense
	controlled_entity.stats_data.base_stats.magic_attack = stats.magic_attack
	controlled_entity.stats_data.base_stats.magic_defense = stats.magic_defense
	
	movement_speed = stats.movement_speed
	
	controlled_entity.can_flinch = stats.can_flinch
	controlled_entity.weight = stats.weight
	
	# Enemy has no mercy by default
	controlled_entity.mercy_timer_max = 0

func _process(delta: float) -> void:
	if controlled_entity == null:
		queue_free()
	
