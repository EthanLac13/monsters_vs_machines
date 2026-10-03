extends "res://scenes/skills/generic_skill.gd"

var slime_ball_scene = load("res://scenes/skills/heroes/slime/slime_shot/SlimeShotSlimeBall.tscn")

var attack_time: int = 30

func _init() -> void:
	charge_frames = 0
	backswing_frames = 0

func _ready() -> void:
	super()
	get_parent().animation_object.change_animation("shoot")
	rotation_degrees = get_parent().move_dir

func _process(delta: float) -> void:
	super(delta)


func move_code():
	charge_timer += 1
	
	if charge_timer == 8:
		var my_slime_ball_node = slime_ball_scene.instantiate()
		my_slime_ball_node.movement_vector = Vector2(cos(rotation), sin(rotation))
		
		var slime_hitbox = my_slime_ball_node.get_node("Hitbox")
		slime_hitbox.damage = get_parent().stats_data.base_stats.magic_attack * 0.5
		slime_hitbox.flinch_weight = 2.0
		slime_hitbox.status_effects = {
			"slime_slowdown": {
				"slow_amount": 0.5,
				"duration": 360
			}
		}
		
		get_parent().get_parent().add_child(my_slime_ball_node)
		my_slime_ball_node.position = get_parent().position
	
	if charge_timer >= attack_time:
		set_backswing()
