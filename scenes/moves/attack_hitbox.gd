extends Area2D

var faction: int = 0

var position_owner: Node2D

var damage: float = 0

var distance_falloff: bool = false
var min_damage_mult: float = 1.0

var flinch: bool = false
var flinch_time: int = 30
var knockback_power: float = 2.0
var flinch_weight: float = 0.0 # Weight of the hitbox; heavier targets are not affected

var multi_target: bool = false
var multi_target_damage_reduction: float = 0.5

func _ready() -> void:
	position_owner = self

func activate():
	process_mode = 0

func deactivate():
	process_mode = 4
