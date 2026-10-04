extends Node2D

var level_data = {}

var current_world: int = 0
var current_map: int = 0
var current_stage: int = 0

var stage_data_path_template: String = "res://data/levels/world_%d/map_%d/stage_%d.json"

# Scene for the object that handles spawning enemies
var character_spawner: Node2D

# Scene for the objects that track which enemies to spawn and when
var enemy_spawner_scene: PackedScene = load("res://scenes/battle/EnemySpawner.tscn")

# List of nodes where we spawn enemies
@export var spawn_zone_nodes: Array[Node2D]
# List of lines the enemies can follow
@export var enemy_tracks: Array[Line2D]

func _ready() -> void:
	# Get character spawner
	character_spawner = get_parent().get_node("CharacterSpawner")
	
	# Load wave data from a file
	level_data = GeneralFunctions.load_json_file(stage_data_path_template % [current_world, current_map, current_stage])
	
	create_enemy_spawners(0)

func create_enemy_spawners(current_wave: int):
	var current_wave_data = level_data.waves[str(current_wave)]
	for spawn in current_wave_data.spawns:
		var enemy_spawner = enemy_spawner_scene.instantiate()
		enemy_spawner.character_spawner_scene = character_spawner
		
		# Set the enemy ID to spawn
		enemy_spawner.enemy_id = spawn.id
		enemy_spawner.enemy_spawn_count = spawn.amount
		
		# Set the enemy's spawn zones
		var spawn_zone_array: Array[Node2D] = []
		if typeof(spawn.spawn_area) == 19 || typeof(spawn.spawn_area) == 28: # array
			for i in range(0, spawn.spawn_area.size() - 1):
				spawn_zone_array.append(spawn_zone_nodes[spawn.spawn_area[i]])
		else:
			spawn_zone_array.append(spawn_zone_nodes[spawn.spawn_area])
		enemy_spawner.enemy_spawn_zones = spawn_zone_array
		
		# Set the enemy's tracks
		var track_array: Array[Line2D] = []
		if typeof(spawn.tracks) == 19 || typeof(spawn.tracks) == 28: # array
			for i in range(0, spawn.tracks.size() - 1):
				track_array.append(enemy_tracks[spawn.tracks[i]])
		else:
			track_array.append(enemy_tracks[spawn.tracks])
		print(track_array)
		enemy_spawner.tracks = track_array
		
		# Set the enemy's spawn time
		var start_secs: float = 0.0
		if typeof(spawn.start_secs) == 19 || typeof(spawn.start_secs) == 28: # array
			start_secs = randf_range(spawn.start_secs[0], spawn.start_secs[1])
		else:
			start_secs = spawn.start_secs
		enemy_spawner.spawn_timer = int(start_secs * 60)
		
		# Sets the enemy's respawn time
		var min_respawn_time: float = 0.0
		var max_respawn_time: float = 0.0
		if typeof(spawn.respawn_secs) == 19 || typeof(spawn.respawn_secs) == 28: # array
			min_respawn_time = spawn.respawn_secs[0]
			max_respawn_time = spawn.respawn_secs[1]
		else:
			min_respawn_time = spawn.respawn_secs
			max_respawn_time = spawn.respawn_secs
		enemy_spawner.respawn_timer_min = int(min_respawn_time * 60)
		enemy_spawner.respawn_timer_max = int(max_respawn_time * 60)
		
		add_child(enemy_spawner)
