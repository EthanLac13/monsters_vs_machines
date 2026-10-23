extends "res://scenes/characters/base_ai_controller.gd"

static var coin_dropper_scene: PackedScene = load("res://scenes/characters/enemies/EnemyCoinDropper.tscn")

var target_crystal_entity: Node2D

var track_line: Line2D
var current_track_node: int
var lost_track: bool = false # Whether we got distracted from following the track


func initialize():
	super()
	target_crystal_entity = get_parent().get_node("TargetCrystal")
	target_entity = player_entity
	
	track_line = controlled_entity.track
	
	# Set enemy's EXP drop
	controlled_entity.exp_yield = stats.exp_yield
	# Set enemy's money drop
	var my_coin_dropper = coin_dropper_scene.instantiate()
	my_coin_dropper.coins_to_drop = stats.money_yield
	controlled_entity.add_child(my_coin_dropper)
	controlled_entity.was_killed.connect(my_coin_dropper.drop_coins)
	
	crystal_chase_dir = stats.crystal_chase_dir + randf_range(stats.crystal_chase_dir_variance * -1, stats.crystal_chase_dir_variance)
	next_node_dir = stats.next_node_dir + randf_range(stats.next_node_dir_variance * -1, stats.next_node_dir_variance)

	

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
