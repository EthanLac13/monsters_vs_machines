extends Node2D

var enemy_list = {}

func _ready() -> void:
	enemy_list = GeneralFunctions.load_json_file("res://data/enemy_scene_data.json")
	#spawn_enemy("res://scenes/characters/enemies/sentry_droid/EnemySentryDroid.tscn", 64, 64)
	spawn_entity("res://scenes/characters/misc/target_crystal/TargetCrystal.tscn", 240, 240, 0, "TargetCrystal")
	#spawn_enemy_from_list(1, 64, 240)

func spawn_enemy_from_list(enemy_id: int, x: float, y: float):
	var selected_enemy_data = enemy_list[str(enemy_id)]
	
	var new_enemy = spawn_entity(selected_enemy_data.scene, x, y, 1, selected_enemy_data.internal_name)
	# Give its health bar a red color
	new_enemy.get_node("HealthBar").modulate = Color(248, 0, 0)
	return new_enemy

func spawn_entity(entity_scene: String, x: float, y: float, entity_faction: int = 0, entity_name: String = ""):
	var new_entity_scene = load("res://scenes/EntityTest.tscn")
	var new_entity = new_entity_scene.instantiate()
	new_entity.name = entity_name
	
	get_parent().add_child.call_deferred(new_entity)
	new_entity.set_sprite.call_deferred(entity_scene)
	new_entity.position.x = x
	new_entity.position.y = y
	new_entity.faction = entity_faction
	
	new_entity.initialize_ai.call_deferred()
	
	return new_entity
