extends Node2D

var movement_vector: Vector2
var move_speed: float = 2.0

var lifetime: int = 75
var fade_time: int = 5
var fade_amount: float = 0.2

func _ready() -> void:
	$Hitbox.position_owner = self

func _process(delta: float) -> void:
	position += movement_vector * move_speed
	lifetime -= 1
	
	if lifetime <= fade_time:
		modulate.a -= fade_amount
	if lifetime <= 0:
		queue_free()
