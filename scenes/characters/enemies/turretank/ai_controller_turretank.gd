extends "res://scenes/characters/enemies/base_enemy_ai_controller.gd"

var projectile_scene: PackedScene = load("res://scenes/skills/enemies/turretank/TurretankProjectile.tscn")

var max_chase_dir: float = 16.0

var is_shooting: bool = false
var shoot_secs: int = 0
var shoot_secs_max: int = 0
var shoot_secs_variance: int = 0

var shoot_angle_variance: float = 0.0

var anim_nodes_initialized: bool = false

var base_head: Node2D
var direction_heads: Array[Node2D] = []

var last_visible_head: Node2D

func initialize():
	super()
	
	shoot_secs = int(stats.shoot_time_secs * 60)
	shoot_secs_max = shoot_secs
	shoot_secs_variance = int(stats.shoot_variance * 60)
	
	shoot_angle_variance = stats.shoot_angle_variance

func _process(delta: float) -> void:
	super(delta)
	
	if anim_nodes_initialized == false:
		anim_nodes_initialized = true
		
		base_head = controlled_entity.animation_object.anim_object.get_node("Body/Pivot/Head")
		direction_heads = [
			base_head.get_node("RightHeadParent"),
			base_head.get_node("DownRightHeadParent"),
			base_head.get_node("DownHeadParent"),
			base_head.get_node("DownLeftHeadParent"),
			base_head.get_node("LeftHeadParent"),
			base_head.get_node("UpLeftHeadParent"),
			base_head.get_node("UpHeadParent"),
			base_head.get_node("UpRightHeadParent"),
			base_head.get_node("RightHeadParent")
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
				
				# Shoot
				if !is_shooting:
					shoot_secs -= 1
					if shoot_secs <= 0:
						is_shooting = true
						shoot_secs = 0
				else:
					shoot_secs += 1
					
					if shoot_secs <= 10:
						base_head.scale.x = 1.0 + (shoot_secs * 0.025)
					elif shoot_secs <= 20:
						base_head.scale.x = 1.25 - ((shoot_secs - 10) * 0.05)
					elif shoot_secs <= 30:
						base_head.scale.x = 0.75 + ((shoot_secs - 20) * 0.025)
					else:
						is_shooting = false
						shoot_secs = shoot_secs_max + randi_range(-shoot_secs_variance, shoot_secs_variance)
					base_head.scale.y = base_head.scale.x
					
					if shoot_secs == 20:
						fire_projectile(move_dir + randf_range(-shoot_angle_variance, shoot_angle_variance))

func fire_projectile(shot_dir: float):
	var projectile_node = projectile_scene.instantiate()
	controlled_entity.get_parent().add_child(projectile_node)
	
	projectile_node.get_node("Hitbox").faction = controlled_entity.faction
	projectile_node.get_node("Hitbox").damage = controlled_entity.stats_data.base_stats.attack
	projectile_node.global_position = controlled_entity.global_position
	projectile_node.movement_vector = Vector2(cos(deg_to_rad(shot_dir)), sin(deg_to_rad(shot_dir)))
	projectile_node.rotation_degrees = shot_dir

func set_head_dir(direction: float):
	# Set the old head to be invisible
	last_visible_head.visible = false
	
	# Set the head sprite based on pointing dir
	var angle_dir = int(((int(direction + 360) % 360) + 22.5) / 45.0)
	last_visible_head = direction_heads[angle_dir]
	
	# Set the new head to be visible
	last_visible_head.visible = true
