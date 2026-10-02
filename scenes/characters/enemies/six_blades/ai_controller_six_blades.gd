extends "res://scenes/characters/base_ai_controller.gd"

var max_chase_dir: float = 16.0
var player_chase_dir: float = 128.0
var crystal_chase_dir: float = 144.0

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

func _process(delta: float) -> void:
	super(delta)
	if controlled_entity != null:
		if !started_animating:
			print("Changing anim")
			controlled_entity.animation_object.change_animation("idle", -1)
			attack_hitbox.position_owner = controlled_entity
			started_animating = true
		if controlled_entity.can_move:
			# Get player's position and move towards it
			var target_pos
			if chasing_player:
				target_pos = target_entity.position
				if controlled_entity.position.distance_to(target_pos) > controlled_entity.position.distance_to(target_crystal_entity.position):
					target_pos = target_crystal_entity.position
					chasing_player = false
			else:
				target_pos = target_crystal_entity.position
				if controlled_entity.position.distance_to(target_entity.position) < controlled_entity.position.distance_to(target_crystal_entity.position):
					target_pos = target_entity.position
					chasing_player = true
			
			# If we're farther than max_chase_dir range away from the target, get closer
			if controlled_entity.position.distance_to(target_pos) >= max_chase_dir:
				var movement_vector = controlled_entity.position.direction_to(target_pos).normalized()
				controlled_entity.move(movement_vector * movement_speed)
		
			
