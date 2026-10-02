extends Node2D

func _ready() -> void:
	spawn_enemy("res://scenes/characters/enemies/six_blades/EnemySixBlades.tscn")

func spawn_enemy(enemy_scene: String):
	var new_enemy_scene = load("res://scenes/EntityTest.tscn")
	var new_enemy = new_enemy_scene.instantiate()
	
	get_parent().add_child.call_deferred(new_enemy)
	new_enemy.set_sprite.call_deferred(enemy_scene)
	new_enemy.position.x = 0
	new_enemy.position.y = 0
	new_enemy.faction = 1
	print(new_enemy)
	
	new_enemy.initialize_ai.call_deferred()
