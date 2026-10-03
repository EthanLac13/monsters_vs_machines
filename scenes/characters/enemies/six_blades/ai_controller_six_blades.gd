extends "res://scenes/characters/base_ai_controller.gd"

var max_chase_dir: float = 16.0
var player_chase_dir: float = 128.0

var chasing_player: bool = true

var started_animating = false

var hitbox_scene = load("res://scenes/skills/enemies/six_blades/SixBladesAttack.tscn")
var attack_node
var attack_hitbox

func initialize():
	super()
	max_chase_dir = stats.max_chase_dir
	
	attack_node = hitbox_scene.instantiate()
	attack_hitbox = attack_node.get_node("Hitbox")
	attack_hitbox.faction = 1
	attack_hitbox.damage = controlled_entity.stats_data.base_stats.attack
	attack_hitbox.flinch = true
	attack_hitbox.flinch_weight = 15.0
	attack_hitbox.multihit = true
	
	controlled_entity.add_child(attack_node)
	controlled_entity.disabled_nodes_on_flinch.append(attack_hitbox)

func _process(delta: float) -> void:
	super(delta)
	if controlled_entity != null:
		if !started_animating:
			print("Changing anim")
			controlled_entity.animation_object.change_animation("idle", -1)
			attack_hitbox.position_owner = controlled_entity
			started_animating = true
		if controlled_entity.can_move:
			# Decide whether to chase the player or follow the track
			var target_pos = get_target_pos()
			
			# If we're farther than max_chase_dir range away from the target, get closer
			if controlled_entity.position.distance_to(target_pos) >= max_chase_dir:
				var movement_vector = controlled_entity.position.direction_to(target_pos).normalized()
				controlled_entity.move(movement_vector * movement_speed)
		
			
