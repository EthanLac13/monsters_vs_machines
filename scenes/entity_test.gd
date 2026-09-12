extends Node2D

var stats_data: Node

@export var faction: int = 0

@export var animation_object: Node2D
@export var collision_area: ShapeCast2D
@export var wall_collider: ShapeCast2D

var can_move: bool = true

var is_moving: bool = false
var was_previously_moving: bool = false

var x_input: float = 0.0
var y_input: float = 0.0

var move_dir: float = 90.0
var previous_move_dir: float = 90.0

var move_speed: float = 2.0

var input_right = false
var input_down = false
var input_left = false
var input_up = false

var using_move: bool = false

var move_list = [
	
]
var move_scenes = [
	
]
var current_move_scene: Node = null

var is_flinching: bool = false
var flinch_timer: int = 0
var flinch_timer_max: int = 0
var knockback_movement: float = 0
var knockback_dir: float = 0.0

var dying: bool = false
var death_timer: int = 0

func _ready() -> void:
	stats_data = $StatsHolder
	animation_object.change_animation("idle", move_dir)

func _process(delta: float) -> void:
	if can_move:
		check_for_movement()
	
	# Move automatically in the direction of knockback
	if is_flinching:
		var knockback_power = knockback_movement * (flinch_timer / float(flinch_timer_max))
		var knockback_vector = Vector2(cos(deg_to_rad(knockback_dir)), sin(deg_to_rad(knockback_dir)))
		move(knockback_vector * knockback_power)
		
		flinch_timer -= 1
		if flinch_timer <= 0:
			is_flinching = false
			can_move = true
			animation_object.change_animation("Idle", move_dir)
	
	# Check for taking hit
	if check_shapecast(collision_area):
		take_hitbox_hit(collision_area.get_collider(0))
		collision_area.clear_exceptions()
		collision_area.add_exception(collision_area.get_collider(0))
	
	# Flow for dying (enemies; players are TODO)
	if dying:
		death_timer += 1
		
		move_dir += 30.0
		if move_dir >= 360:
			move_dir -= 360.0
		
		if death_timer % 3 == 2:
			animation_object.change_animation("Hurt", move_dir)
		
		if death_timer >= 25 && death_timer < 35:
			modulate.a -= 0.1
		
		if death_timer == 35:
			queue_free()
	
	# Reset inputs
	input_right = false
	input_down = false
	input_left = false
	input_up = false


func check_for_movement():
	was_previously_moving = is_moving
	is_moving = false
	
	# Get total movement input based on x and y components
	x_input = 0.0
	y_input = 0.0
	previous_move_dir = move_dir
	
	if input_right:
		x_input = 1.0
	elif input_left:
		x_input = -1.0
	
	if input_down:
		y_input = 1.0
	elif input_up:
		y_input = -1.0
	
	var total_input = Vector2(x_input, y_input).normalized()
	#print(total_input)
	
	if total_input != Vector2.ZERO:
		is_moving = true
		
		# Set direction based on current input
		move_dir = rad_to_deg(total_input.angle())
		
		if move_dir != previous_move_dir:
			animation_object.change_direction(move_dir)
	
	# Move and change animations
	if is_moving: # Set walk animation when moving
		move(total_input * move_speed)
		if !was_previously_moving:
			animation_object.change_animation("walk", move_dir)
	else: # Set idle animation when no longer moving
		if was_previously_moving:
			move_absolute(roundf(position.x), roundf(position.y))
			animation_object.change_animation("idle", move_dir)

# Instantly checks the collision of a shapecast for any Area2Ds
func check_shapecast(shapecast_to_check: ShapeCast2D):
	shapecast_to_check.force_shapecast_update()
	if shapecast_to_check.is_colliding():
		return true
	return false

# Moves in a specific direction; will be obstructed by walls
func move(movement_input: Vector2):
	# X movement component
	var last_position_x = position.x
	
	position.x += movement_input.x
	
	if check_shapecast(wall_collider):
		position.x = last_position_x
	
	# Y movement component
	var last_position_y = position.y
	
	position.y += movement_input.y
	
	if check_shapecast(wall_collider):
		position.y = last_position_y

# Moves to an absolute position; will be obstructed by walls
func move_absolute(new_pos_x: float, new_pos_y: float):
	# X movement component
	var last_position_x = position.x
	
	position.x = new_pos_x
	
	wall_collider.force_shapecast_update()
	if wall_collider.is_colliding():
		position.x = last_position_x
	
	# Y movement component
	var last_position_y = position.y
	
	position.y = new_pos_y
	
	wall_collider.force_shapecast_update()
	if wall_collider.is_colliding():
		position.y = last_position_y


# Attempts to use a move from the array of moves
func attempt_use_move(move_index: int):
	if !using_move:
		current_move_scene = move_scenes[move_index].instantiate()
		add_child(current_move_scene)
		current_move_scene.position.x = 0
		current_move_scene.position.y = 0
		using_move = true
		can_move = false

# Register getting hit by a hitbox
func take_hitbox_hit(hitbox: Area2D):
	if hitbox.faction != faction:
		stats_data.hp -= hitbox.damage
		update_health_bar()
		if stats_data.hp > 0:
			if hitbox.flinch:
				can_move = false
				is_flinching = true
				flinch_timer = hitbox.flinch_time
				flinch_timer_max = flinch_timer
				knockback_movement = hitbox.knockback_power
				knockback_dir = rad_to_deg(get_angle_to(hitbox.position_owner.position)) + 180.0
				move_dir = knockback_dir - 180.0
				animation_object.change_animation("hurt")
				animation_object.hop(flinch_timer * 0.5)
		else:
			set_death_state()
			is_flinching = true
			flinch_timer = 80
			flinch_timer_max = 80
			knockback_movement = 2.0
			knockback_dir = rad_to_deg(get_angle_to(hitbox.position_owner.position)) + 180.0

# Update HP bar percentage
func update_health_bar():
	$HealthBar.value = stats_data.hp / float(stats_data.max_hp)

func set_death_state():
	dying = true
	can_move = false
	animation_object.change_animation("hurt")
	animation_object.hop(30.0, 20.0)
