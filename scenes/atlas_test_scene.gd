extends Node2D

var index_number: int = 4

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

var is_animating: bool = false
var is_looping: bool = true

var current_anim_frame: int = 0
var current_anim_timer: int = 0
var max_anim_timer: int = 0 # Threshold at which we swap to the next frame

var current_animation

var current_animation_string = "Walk"
var current_direction_string = "down"

var anim_sheet_width_in_frames: int = 0

var animations = {}

func _ready() -> void:
	$Body.texture = load("res://sprites/pokemon_sprites/%d/Anim.png" % index_number)
	load_animations()
	print(animations["Sleep"])
	
	# Set amount of hframes and vframes
	print($Body.texture.get_width())
	print($Body.texture.get_height())
	
	$Body.hframes = $Body.texture.get_width() / animations.frame_width
	$Body.vframes = $Body.texture.get_height() / animations.frame_height
	
	anim_sheet_width_in_frames = $Body.texture.get_size().x / animations.frame_width
	print(anim_sheet_width_in_frames)
	
	change_animation("Walk", 0, false)

func _process(delta: float) -> void:
	if is_animating:
		animate()


func load_animations():
	var xml_data = XML.parse_file("res://sprites/pokemon_sprites/%d/FrameData.xml" % index_number)
	
	animations.frame_width = xml_data.root.children[0].content.to_int()
	animations.frame_height = xml_data.root.children[1].content.to_int()
	$Body.region_rect = Rect2(0, 0, animations.frame_width, animations.frame_height)
	
	var anims_parent = xml_data.root.get_child_with_name("Anims")
	print(anims_parent.children)
	
	for anim_node in anims_parent.children:
		
		var evaluated_node = anim_node
		if evaluated_node.get_child_with_name("CopyOf") != null:
			var copy_anim = evaluated_node.get_child_with_name("CopyOf").content
			for new_anim_node in anims_parent.children:
				if new_anim_node.get_child_with_name("Name").content == copy_anim:
					evaluated_node = new_anim_node
					break
		
		print(evaluated_node.get_child_with_name("Name").content)
		# Start loading total animation data
		var total_anim_data = {}
		var direction_index = 0
		
		var anim_sequences = evaluated_node.get_child_with_name("Sequences")
		if anim_sequences != null:
			for anim_sequence in anim_sequences.children:
				var anim_data = {
					frames = []
				}
				for anim_frame in anim_sequence.children:
					var frame_data = {
						index = 0,
						duration = 0,
						flip = false,
						offset = [0, 0],
						shadow = [0, 0]
					}
					
					frame_data.index = anim_frame.get_child_with_name("FrameIndex").content.to_int()
					frame_data.duration = anim_frame.get_child_with_name("Duration").content.to_int()
					if anim_frame.get_child_with_name("HFlip").content.to_int() == 1:
						frame_data.flip = true
					
					frame_data.offset[0] = anim_frame.get_child_with_name("Sprite").get_child_with_name("XOffset").content.to_int()
					frame_data.offset[1] = anim_frame.get_child_with_name("Sprite").get_child_with_name("YOffset").content.to_int()
					
					frame_data.shadow[0] = anim_frame.get_child_with_name("Shadow").get_child_with_name("XOffset").content.to_int()
					frame_data.shadow[1] = anim_frame.get_child_with_name("Shadow").get_child_with_name("YOffset").content.to_int()
					
					anim_data.frames.append(frame_data)
				
				# Add the animation data for this direction to the dictionary for animations
				if anim_sequences.children.size() == 1: # Single-direction animation
					total_anim_data[direction_single] = anim_data
					direction_index += 1
				else: # Eight-direction animation
					total_anim_data[direction_map[direction_index]] = anim_data
					direction_index += 1
		animations[anim_node.get_child_with_name("Name").content] = total_anim_data
			
		#print(animations.walk)
			

func animate():
	current_anim_timer += 1
	if current_anim_timer >= max_anim_timer:
		current_anim_frame += 1
		if current_anim_frame >= current_animation.frames.size():
			if is_looping:
				current_anim_frame = 0
			else:
				is_animating = false
				return
		
		current_anim_timer = 0
		max_anim_timer = current_animation.frames[current_anim_frame].duration
		
		set_anim_frame(current_animation.frames[current_anim_frame].index)
		
		$Body.position.x = current_animation.frames[current_anim_frame].offset[0]
		$Body.position.y = current_animation.frames[current_anim_frame].offset[1]
		
		$Shadow.position.x = current_animation.frames[current_anim_frame].shadow[0]
		$Shadow.position.y = current_animation.frames[current_anim_frame].shadow[1]
		
		if current_animation.frames[current_anim_frame].flip:
			$Body.scale.x = -1
		else:
			$Body.scale.x = 1

func change_animation(anim_name: String, anim_dir: float = 0, reset: bool = true, loop: bool = true):
	is_animating = true
	is_looping = loop
	
	current_animation_string = anim_name
	current_direction_string = direction_to_string_dict[get_snapped_anim_dir(anim_dir)]
	if animations[current_animation_string].size() == 1:
		current_direction_string = "single"
	
	current_animation = animations[current_animation_string][current_direction_string]
	
	var current_frame = current_animation.frames[0].index
	set_anim_frame(current_frame)
	
	if reset:
		current_anim_frame = 0
		current_anim_timer = 0
		max_anim_timer = current_animation.frames[current_anim_frame].duration
		
	$Body.position.x = current_animation.frames[current_anim_frame].offset[0]
	$Body.position.y = current_animation.frames[current_anim_frame].offset[1]
	
	$Shadow.position.x = current_animation.frames[current_anim_frame].shadow[0]
	$Shadow.position.y = current_animation.frames[current_anim_frame].shadow[1]
		
	if current_animation.frames[current_anim_frame].flip:
		$Body.scale.x = -1
	else:
		$Body.scale.x = 1

func set_anim_frame(current_image):
	$Body.frame = current_image

func change_direction(new_dir: float):
	change_animation(current_animation_string, new_dir, true, is_looping)

# Snaps an animation to the nearest multiple of 45
func get_snapped_anim_dir(anim_dir: float):
	var snapped_dir: int = snapped(anim_dir, 45)
	if snapped_dir < 0:
		snapped_dir += 360
	return snapped_dir

func hop(hop_frames: float = 1.0, hop_height: float = 10.0):
	$AnimationPlayer.speed_scale = 60.0 / hop_frames
	$AnimationPlayer.get_animation("hop").track_set_key_value(0, 1, Vector2(-1, -5 - hop_height))
	$AnimationPlayer.play("hop")
