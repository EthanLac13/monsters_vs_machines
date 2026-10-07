extends "res://scenes/pickups/generic_pickup.gd"

var anim_timer: int = 0
var anim_timer_max: int = 4
var anim_frame: int = 0

var value: int = 1

@export var pickup_scene: PackedScene

func _process(delta: float) -> void:
	super(delta)
	anim_timer += 1
	if anim_timer >= anim_timer_max:
		anim_frame += 1
		anim_frame %= 4
		$Sprite.frame = anim_frame
		anim_timer = 0

func player_touched(collider: Area2D):
	var player = collider.get_parent().get_parent()
	player.ai_controller.add_money(value)
	
	# Spawn the glitter effect
	var my_particles = pickup_scene.instantiate()
	get_parent().add_child(my_particles)
	my_particles.position = position
	
	super(collider)
