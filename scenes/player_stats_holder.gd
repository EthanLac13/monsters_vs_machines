extends "res://scenes/stats_holder.gd"

var level_1_stats = {
	hp = 0,
	attack = 0.0,
	defense = 0.0,
	magic_attack = 0.0,
	magic_defense = 0.0,
	speed = 0.0
}
var max_level_stats = {
	hp = 0,
	attack = 0.0,
	defense = 0.0,
	magic_attack = 0.0,
	magic_defense = 0.0,
	speed = 0.0
}

func level_up_stats(current_level: float, max_level: float):
	var lerp_amount = current_level / max_level
	
	var new_hp = lerp(level_1_stats.hp, max_level_stats.hp, lerp_amount)
	var old_hp = float(max_hp)
	max_hp = ceil(new_hp)
	hp *= (new_hp / old_hp)
	
	var new_attack = lerp(level_1_stats.attack, max_level_stats.attack, lerp_amount)
	base_stats.attack = new_attack
	
	recalculate_stats()
