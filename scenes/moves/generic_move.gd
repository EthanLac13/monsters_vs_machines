extends Node2D

var state: int = 0
var charge_timer: int = 0

var power: int

var types: Array[String]

var charge_frames: int = 30
var backswing_frames: int = 30

func _ready() -> void:
	get_parent().animation_object.change_animation("Shoot", get_parent().move_dir)

func _process(delta: float) -> void:
	match state:
		0: # Charging
			charge_timer += 1
			if charge_timer >= charge_frames:
				state = 1
				charge_timer = 0
		
		1: # Using the move
			move_code()
		
		2: # Backswing
			charge_timer += 1
			if charge_timer >= backswing_frames:
				end_attack()

func move_code():
	state = 2
	charge_timer = 0

func set_backswing():
	if backswing_frames == 0:
		end_attack()
	else:
		state = 2
		charge_timer = 0

func end_attack():
	get_parent().animation_object.change_animation("Idle", get_parent().move_dir)
	get_parent().using_move = false
	get_parent().can_move = true
	queue_free()
