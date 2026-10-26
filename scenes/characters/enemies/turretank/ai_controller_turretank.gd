extends "res://scenes/characters/enemies/base_enemy_ai_controller.gd"

var max_chase_dir: float = 16.0

var anim_nodes_initialized: bool = false

var right_head: Node2D
var down_head: Node2D
var left_head: Node2D
var up_head: Node2D

var direction_heads: Array[Node2D] = []

var last_visible_head: Node2D

func initialize():
	super()

func _process(delta: float) -> void:
	super(delta)
	
	if anim_nodes_initialized == false:
		anim_nodes_initialized = true
		
		direction_heads = [
			controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head/RightHeadParent"),
			controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head/DownRightHeadParent"),
			controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head/DownHeadParent"),
			controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head/DownLeftHeadParent"),
			controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head/LeftHeadParent"),
			controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head/UpLeftHeadParent"),
			controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head/UpHeadParent"),
			controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head/UpRightHeadParent"),
			controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head/RightHeadParent")
		]
		
		last_visible_head = direction_heads[2]
	
	if controlled_entity != null:
		if controlled_entity.can_move && !controlled_entity.using_skill && !controlled_entity.is_flinching:
			
			# Decide whether to chase the player or follow the track
			var target_pos = get_target_pos()
			
			# If we're farther than max_chase_dir range away from the target, get closer
			if controlled_entity.position.distance_to(target_pos) >= max_chase_dir:
				var movement_vector = controlled_entity.position.direction_to(target_pos).normalized()
				var movement_speed = controlled_entity.get_effective_move_speed()
				controlled_entity.move(movement_vector * movement_speed)
				
				# Change our direction based on movement
				var move_dir: float = rad_to_deg(movement_vector.angle())
				controlled_entity.move_dir = move_dir
				controlled_entity.animation_object.change_direction(move_dir)
				
				crystal_chase_dir = 128.0
				target_pos = player_entity.position#get_target_pos()
				crystal_chase_dir = 0.0
				
				movement_vector = controlled_entity.position.direction_to(target_pos).normalized()
				move_dir = rad_to_deg(movement_vector.angle())
				
				# Change cannon angle based on direction to target entity
				set_head_dir(move_dir)

func set_head_dir(direction: float):
	# Set the old head to be invisible
	last_visible_head.visible = false
	
	# Set the head sprite based on pointing dir
	var angle_dir = int(((int(direction + 360) % 360) + 22.5) / 45.0)
	last_visible_head = direction_heads[angle_dir]
	
	# Set the new head to be visible
	last_visible_head.visible = true
