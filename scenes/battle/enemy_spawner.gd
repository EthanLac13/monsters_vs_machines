extends Node2D

var character_spawner_scene: Node2D

var enemy_id: int
var enemy_spawn_count: int
var enemy_spawn_zones: Array[Node2D]
var tracks: Array[Line2D]

var spawn_timer: int = 0
var respawn_timer_min: int = 0
var respawn_timer_max: int = 0

signal enemy_was_spawned(id: int)

func _process(delta: float) -> void:
	spawn_timer -= 1
	
	if spawn_timer <= 0:
		# Randomly select a spawn zone to spawn the enemy at
		var my_spawn_zone = enemy_spawn_zones[randi_range(0, enemy_spawn_zones.size() - 1)]
		
		# Make the character spawner spawn the enemy
		var spawned_enemy = character_spawner_scene.spawn_enemy_from_list(enemy_id, my_spawn_zone.position.x, my_spawn_zone.position.y)
		enemy_was_spawned.emit(enemy_id)
		
		# Give the enemy its track
		spawned_enemy.track = tracks[randi_range(0, tracks.size() - 1)]
		
		# Deduct the enemy
		enemy_spawn_count -= 1
		if enemy_spawn_count <= 0: # If we're out of enemies, destroy ourself
			queue_free()
		else: # Otherwise, set the spawn timer to between our respawn timers, randomly
			spawn_timer = randi_range(respawn_timer_min, respawn_timer_max)
