extends Node2D

@export var controlled_object: Node2D

@export var hud: CanvasLayer

var player_stat_file
var player_stat_data

var exp_handler_scene: PackedScene = load("res://scenes/battle/EXPHandler.tscn")

var spawned_enemy

func _ready() -> void:
	controlled_object.ai_controller = self
	controlled_object.hud = hud
	
	# Set player's stats
	player_stat_file = GeneralFunctions.load_json_file("res://data/player_stat_data.json")
	player_stat_data = player_stat_file["0"]
	set_player_stats.call_deferred()
	
	# Hide player's mini HP bar
	controlled_object.get_node("HealthBar").visible = false
	controlled_object.took_damage.connect(_on_player_damaged)
	
	# Add EXP points handler to player
	var my_exp_handler = exp_handler_scene.instantiate()
	add_child(my_exp_handler)

func _process(delta: float):
	if Input.is_action_pressed("InputRight"):
		controlled_object.input_right = true
	if Input.is_action_pressed("InputLeft"):
		controlled_object.input_left = true
	
	if Input.is_action_pressed("InputDown"):
		controlled_object.input_down = true
	if Input.is_action_pressed("InputUp"):
		controlled_object.input_up = true
	
	if Input.is_action_just_pressed("UseMove1"):
		controlled_object.attempt_use_move(0)
	if Input.is_action_just_pressed("UseMove2"):
		controlled_object.attempt_use_move(1)

func _on_player_damaged():
	hud.update_health_bar(controlled_object.stats_data.hp, controlled_object.stats_data.max_hp)

func set_player_stats():
	var stats = controlled_object.stats_data
	stats.script = load("res://scenes/player_stats_holder.gd")
	
	
	# Set player's default stats
	stats.hp = player_stat_data.base_stats.hp
	stats.base_stats.attack = player_stat_data.base_stats.attack
	stats.base_stats.defense = player_stat_data.base_stats.defense
	stats.base_stats.magic_attack = player_stat_data.base_stats.magic_attack
	stats.base_stats.magic_defense = player_stat_data.base_stats.magic_defense
	controlled_object.move_speed = player_stat_data.base_stats.move_speed
	
	# Set player's level 1 and level max stats
	stats.level_1_stats = player_stat_data.base_stats.duplicate(true)
	stats.max_level_stats = player_stat_data.max_level_stats.duplicate(true)
	
	controlled_object.stats_data.recalculate_stats()
