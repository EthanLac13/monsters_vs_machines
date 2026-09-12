extends Node2D

var anim_object: Node2D # Visual sprite of this character
var anim_player: AnimationPlayer # The animation player object of the character

var current_animation_string = "idle" # The current animation we're playing
var current_external_animation_string = "idle" # The animation the entity has told us to play; gets converted
var current_direction_string = "down" # The current direction we're using for the animation
var last_anim_dir: int = -1 # The last direction we were animating in, from 0 to 360

# Dictionary that maps input directions to direction strings
static var direction_to_string_dict = {
	0: "right",
	#45: "down_right",
	90: "down",
	#135: "down_left",
	180: "left",
	#225: "up_left",
	270: "up",
	#315: "up_right",
	360: "right"
}

var animation_map = {} # Map that converts external animations to internal ones; loaded from the anim object
var next_animation_map = {} # Map that tells us the next animation in a sequence; loaded from the anim object

func _ready() -> void:
	anim_object = $AnimObject
	animation_map = $AnimObject.animation_map
	next_animation_map = $AnimObject.next_animation_map
	
	anim_player = $AnimObject.get_node("AnimationPlayer")
	anim_player.animation_finished.connect(_on_animation_finished)

func change_animation(new_anim: String, anim_dir: int = -1):
	# Reset the current animation
	anim_player.play("RESET")
	anim_player.seek(0)
	
	if anim_dir == -1: # If no direction is specified, play the animation with no direction at the end
		current_direction_string = "none"
		anim_player.play(animation_map[new_anim])
	else: # Otherwise, play it in the proper direction
		current_direction_string = direction_to_string_dict[get_snapped_anim_dir(anim_dir)]
		anim_player.play(animation_map[new_anim] + "_" + current_direction_string)
	# Use seek(0) to ensure players don't see one frame of RESET by mistake
	anim_player.seek(0)
	
	current_external_animation_string = new_anim
	current_animation_string = animation_map[new_anim]
	last_anim_dir = anim_dir

# Changes direction while maintaining the same animation and progress
func change_direction(anim_dir: int):
	var new_direction_string = direction_to_string_dict[get_snapped_anim_dir(anim_dir)]
	if new_direction_string != current_direction_string:
		var anim_progress = anim_player.current_animation_position
		change_animation(current_external_animation_string, anim_dir)
		if anim_progress < anim_player.current_animation_length:
			anim_player.seek(anim_progress, true)

# Snaps an animation to the nearest multiple of 90
func get_snapped_anim_dir(anim_dir: float):
	var snapped_dir: int = snapped(anim_dir, 90)
	if snapped_dir < 0:
		snapped_dir += 360
	return snapped_dir

# Called when an animation finishes without looping
func _on_animation_finished(anim_name):
	if next_animation_map.has(current_animation_string):
		# Reset the current animation
		anim_player.play("RESET")
		anim_player.seek(0)
		# Go to the next animation
		anim_player.play(next_animation_map[current_animation_string] + "_" + current_direction_string)
		anim_player.seek(0)
		# Get the next animation in the list
		current_animation_string = next_animation_map[current_animation_string]
