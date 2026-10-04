extends Node

# Entity stats
var base_stats = {
	attack = 0.0,
	defense = 0.0,
	magic_attack = 0.0,
	magic_defense = 0.0
}

var hp: int = 100
var max_hp: int = 100

var attack: float = 0.0
var defense: float = 0.0
var magic_attack: float = 0.0
var magic_defense: float = 0.0

func _ready() -> void:
	recalculate_stats()

func recalculate_stats():
	attack = base_stats.attack
	defense = base_stats.defense
	magic_attack = base_stats.magic_attack
	magic_defense = base_stats.magic_defense
