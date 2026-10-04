extends Node2D

var controlled_entity: Node2D
var target_entity: Node2D
var player_entity: Node2D
var target_crystal_entity: Node2D

var track_line: Line2D
var current_track_node: int
var lost_track: bool = false # Whether we got distracted from following the track

var stats

var crystal_chase_dir: float = 128.0
var next_node_dir: float = 24.0

func initialize():
	player_entity = get_parent().get_node("Player")
	target_crystal_entity = get_parent().get_node("TargetCrystal")
	target_entity = player_entity
	
	track_line = get_parent().get_node("EnemyTrack0")
	
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
	
	controlled_entity.exp_yield = stats.exp_yield
	
	controlled_entity.can_flinch = stats.can_flinch
	controlled_entity.weight = stats.weight
	
	crystal_chase_dir = stats.crystal_chase_dir + randf_range(stats.crystal_chase_dir_variance * -1, stats.crystal_chase_dir_variance)
	next_node_dir = stats.next_node_dir + randf_range(stats.next_node_dir_variance * -1, stats.next_node_dir_variance)
	
	# Enemy has no mercy by default
	controlled_entity.mercy_timer_max = 0
	
	# Set enemy's collision
	if controlled_entity.faction == 1:
		controlled_entity.wall_collider.collision_mask = 513
		controlled_entity.collision_blocker.collision_layer = 256

func _process(delta: float) -> void:
	if controlled_entity == null:
		queue_free()
	

func get_target_pos():
	# Get player's position and move towards it
	var target_pos = target_entity.position
	
	# Check if player is obstructed
	var player_obstructed = false
	controlled_entity.wall_collider.add_exception(target_entity.collision_blocker)
	controlled_entity.wall_collider.target_position = target_pos - controlled_entity.position
	player_obstructed = controlled_entity.check_shapecast(controlled_entity.wall_collider)
	controlled_entity.wall_collider.target_position = Vector2(0, 0)
	controlled_entity.wall_collider.remove_exception(target_entity.collision_blocker)
	
	# If the player is too far away, follow the track towards the crystal
	if controlled_entity.position.distance_to(target_pos) >= crystal_chase_dir || player_obstructed:
		# If we've ended the track, make a beeline for the crystal
		if current_track_node >= track_line.points.size():
			target_pos = target_crystal_entity.position
		# Otherwise, follow the track and go to the next node if we reach the current one
		else:
			# If we were distracted, then return to the closest node
			if lost_track:
				var min_track_node_index: int = 0
				var min_track_node_distance: float = 99999.9 # Initialize with a high distance so any node will be lower
				for i in range(0, track_line.points.size()):
					if controlled_entity.position.distance_to(track_line.position + track_line.points[i]) < min_track_node_distance:
						min_track_node_index = i
						min_track_node_distance = controlled_entity.position.distance_to(track_line.position + track_line.points[i])
				current_track_node = min_track_node_index
				lost_track = false
			
			target_pos = track_line.position + track_line.points[current_track_node]
			if controlled_entity.position.distance_to(target_pos) <= next_node_dir:
				current_track_node += 1
	else:
		lost_track = true
		current_track_node = -1
	
	return target_pos
