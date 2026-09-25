extends Node2D

var controlled_entity: Node2D
var target_entity: Node2D

var stats

var movement_speed: float = 0.0

func initialize():
	target_entity = get_parent().get_parent().get_node("Player")
	
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

func _process(delta: float) -> void:
	if controlled_entity == null:
		queue_free()
