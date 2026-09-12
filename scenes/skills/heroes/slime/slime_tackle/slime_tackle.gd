extends "res://scenes/skills/generic_move.gd"

var attack_time: int = 30

var rush_times = [5, 10, 15, 20]

var rush_speed_start = 4.0
var rush_speed_medium = 3.5
var rush_speed_end = 2.0

var rush_vector: Vector2

var sprite: Sprite2D

func _ready() -> void:
	super()
	charge_frames = 5
	backswing_frames = 0
	
	# Set hitbox damage; will be expanded later
	$Hitbox.damage = 30
	$Hitbox.flinch = true
	$Hitbox.position_owner = get_parent()
	
	# Get movement direction for rush
	rush_vector = Vector2(cos(deg_to_rad(get_parent().move_dir)), sin(deg_to_rad(get_parent().move_dir)))
	
	rotation_degrees = get_parent().move_dir

func _process(delta: float) -> void:
	super(delta)


func move_code():
	charge_timer += 1
	if charge_timer == 1:
		get_parent().animation_object.change_animation("idle")
	
	if charge_timer >= rush_times[0] && charge_timer < rush_times[1]:
		get_parent().move(rush_vector * rush_speed_start)
	if charge_timer >= rush_times[1] && charge_timer < rush_times[2]:
		get_parent().move(rush_vector * rush_speed_medium)
	if charge_timer >= rush_times[2] && charge_timer < rush_times[3]:
		get_parent().move(rush_vector * rush_speed_end)
	
	if charge_timer == rush_times[0]: # Activate the hitbox when we begin charging
		$Hitbox.activate()
	if charge_timer == rush_times[1]: # Reduce knockback when slowing diwn
		$Hitbox.flinch_time *= 0.5
		$Hitbox.knockback_power *= 0.5
	if charge_timer == rush_times[2]: # Sourspot late in the attack
		$Hitbox.damage *= 0.5
		$Hitbox.flinch = false
	if charge_timer == rush_times[3]: # Stop the hitbox once we stop charging
		$Hitbox.deactivate()
	
	if charge_timer >= attack_time:
		set_backswing()
