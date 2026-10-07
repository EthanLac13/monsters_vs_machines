extends Node2D

var pre_explosion_time: int = randi_range(15, 25)
var current_frame: int = 0
var frame_time: int = 0
var frame_time_max: int = 3

var dying_entity: Node2D

func _process(delta: float) -> void:
	if pre_explosion_time == 0:
		frame_time += 1
		if frame_time >= frame_time_max:
			current_frame += 1
			if current_frame == 7:
				queue_free()
			else:
				$Sprite.frame = current_frame
			
			if current_frame == 3:
				dying_entity.global_position = global_position
				dying_entity.die()
				
			frame_time = 0
	else:
		pre_explosion_time -= 1
		if pre_explosion_time == 0:
			visible = true
			dying_entity.visible = false
			global_position = dying_entity.global_position
