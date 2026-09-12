extends Node2D

@export var controlled_object: Node2D

func _ready() -> void:
	var new_enemy_scene = load("res://scenes/EntityTest.tscn")
	var new_enemy = new_enemy_scene.instantiate()
	get_parent().add_child.call_deferred(new_enemy)
	new_enemy.position.x = 0
	new_enemy.position.y = 0
	new_enemy.faction = 1
	print(new_enemy)

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
