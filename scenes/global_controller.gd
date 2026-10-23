extends Node2D

func _ready() -> void:
	StringData.update_language("en-USA")
	
	go_to_new_scene("res://scenes/MainScene.tscn")

# Open a new main scene from a specified path
func go_to_new_scene(new_scene_path):
	#print(new_scene_path)
	
	ResourceLoader.load_threaded_request(new_scene_path)
	for child_scene in get_children():
		child_scene.queue_free()
	var my_new_scene = ResourceLoader.load_threaded_get(new_scene_path)
	add_child(my_new_scene.instantiate())
	get_tree().paused = false
