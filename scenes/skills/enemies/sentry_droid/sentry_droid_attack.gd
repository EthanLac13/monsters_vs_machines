extends "res://scenes/skills/generic_skill.gd"

var attack_time: int = 75

var sprite: Sprite2D

func _ready() -> void:
	super()
	charge_frames = 0
	backswing_frames = 0
	
	# Set hitbox damage; will be expanded later
	$Hitbox.damage = get_parent().stats_data.base_stats.attack
	$Hitbox.faction = 1
	$Hitbox.flinch = true
	$Hitbox.multihit = true
	$Hitbox.position_owner = get_parent()
	
	rotation_degrees = get_parent().move_dir

func _process(delta: float) -> void:
	super(delta)


func move_code():
	charge_timer += 1
	
	if charge_timer == 35: # Activate the hitbox
		$Hitbox.activate()
	if charge_timer == 40: # Stop the hitbox
		$Hitbox.deactivate()
	
	if charge_timer >= attack_time:
		end_attack()
