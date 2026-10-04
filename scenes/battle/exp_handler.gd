extends Node2D

var current_level: int = 0
var max_level: int = 20

var current_exp: int = 0
var exp_to_next_level: int = 100
var added_level_exp: int = 50

# Adds EXP and checks for level-ups
func add_exp(given_exp: int = 0):
	if given_exp != 0:
		current_exp += given_exp
		
		while current_exp >= exp_to_next_level: # We can level up multiple times off of one instance of EXP
			level_up()
			current_exp -= exp_to_next_level # Remove this EXP, since we got to the next level
			exp_to_next_level += added_level_exp # Next level takes more EXP to get to
	
	get_parent().hud.update_exp_bar(current_exp, exp_to_next_level)

# Increments level and recalculates stats
func level_up():
	current_level += 1
	get_parent().hud.update_level(current_level)
