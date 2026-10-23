extends Node2D

var movement_vector: Vector2
var move_speed: float = 4.0

var lifetime: int = 35
var fade_time: int = 5
var fade_amount: float = 0.2

func _ready() -> void:
	$Hitbox.position_owner = self
	$Hitbox.hit_landed.connect(_on_hitbox_hit)

func _process(delta: float) -> void:
	position += movement_vector * move_speed
	# Update z-index based on position to avoid z-fighting
	z_index = int(position.y) * 10
	
	lifetime -= 1
	
	if lifetime <= fade_time:
		modulate.a -= fade_amount
	if lifetime <= 0:
		queue_free()

func _on_hitbox_hit():
	queue_free()
