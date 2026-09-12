extends Node2D

var anim_player: AnimationPlayer

var current_animation_string = "idle"
var current_direction_string = "down"

static var direction_map = [
	"down",
	"down_left",
	"left",
	"up_left",
	"up",
	"up_right",
	"right",
	"down_right"
]
static var direction_single = "single"

static var direction_to_string_dict = {
	0: "right",
	45: "down_right",
	90: "down",
	135: "down_left",
	180: "left",
	225: "up_left",
	270: "up",
	315: "up_right",
	360: "right"
}

var animation_map = {
	"idle": "idle",
	"walk": "jump_start"
}
var next_animation_map = {
	"jump_start": "jump_middle",
	"jump_middle": "jump_end",
	"jump_end": "jump_start"
}

func _ready() -> void:
	anim_player = $AnimObject.get_node("AnimationPlayer")

func change_animation(new_anim: String, anim_dir: int = -1):
	if anim_dir == -1:
		current_direction_string = "none"
		anim_player.play(animation_map[new_anim])
	else:
		current_direction_string = direction_to_string_dict[get_snapped_anim_dir(anim_dir)]
		anim_player.play(animation_map[new_anim] + "_" + current_direction_string)

# Snaps an animation to the nearest multiple of 45
func get_snapped_anim_dir(anim_dir: float):
	var snapped_dir: int = snapped(anim_dir, 45)
	if snapped_dir < 0:
		snapped_dir += 360
	return snapped_dir
