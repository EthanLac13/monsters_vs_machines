extends Node2D

func _ready() -> void:
	#spawn_enemy("res://scenes/characters/enemies/sentry_droid/EnemySentryDroid.tscn", 64, 64)
	spawn_entity("res://scenes/characters/misc/target_crystal/TargetCrystal.tscn", 240, 240, 0, "TargetCrystal")
	spawn_enemy("res://scenes/characters/enemies/six_blades/EnemySixBlades.tscn", 64, 64)

func spawn_enemy(enemy_scene: String, x: float, y: float, name: String = ""):
	var new_enemy = spawn_entity(enemy_scene, x, y, 1, name)
	# Give its health bar a red color
	new_enemy.get_node("HealthBar").modulate = Color(248, 0, 0)
	return new_enemy

func spawn_entity(entity_scene: String, x: float, y: float, entity_faction: int = 0, name: String = ""):
	var new_entity_scene = load("res://scenes/EntityTest.tscn")
	var new_entity = new_entity_scene.instantiate()
	new_entity.name = name
	print(new_entity.name)
	
	get_parent().add_child.call_deferred(new_entity)
	new_entity.set_sprite.call_deferred(entity_scene)
	new_entity.position.x = x
	new_entity.position.y = y
	new_entity.faction = entity_faction
	print(new_entity)
	
	new_entity.initialize_ai.call_deferred()
	
	return new_entity
