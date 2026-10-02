extends "res://scenes/characters/base_ai_controller.gd"

var max_chase_dir: float = 16.0

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
	attack_hitbox.damage = 1
	attack_hitbox.flinch = true
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
			var target_pos = target_entity.position
			
			# If we're farther than max_chase_dir range away from the target, get closer
			if controlled_entity.position.distance_to(target_pos) >= max_chase_dir:
				var movement_vector = controlled_entity.position.direction_to(target_pos).normalized()
				controlled_entity.move(movement_vector * movement_speed)
			
