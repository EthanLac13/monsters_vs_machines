extends "res://scenes/characters/enemies/enemy_stat_block.gd"

# Map that converts external animations to internal ones.
# For example, we can get a "walk" input and play our "jump_start" anim.
var animation_map = {
	"idle": "idle",
	"walk": "idle",
	"hurt": "hurt",
	"death": "hurt"
}

# Map that tells us the next animation to play after one is done.
# This lets us have multiple looping animations.
# If you want a sequence to end after a specific anim, leave out the entry for that anim.
# For example, deleting the last "jump_end" entry would make the slime only jump once.
var next_animation_map = {
	
}

# Map that tells us which animations are unidirectional.
var directional_anims = {
	"idle": false,
	"hurt": false
}
