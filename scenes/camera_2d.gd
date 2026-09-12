extends Camera2D

func _ready() -> void:
	var window_size_x = 960
	var window_size_y = 540
	
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		
		get_viewport().size.x = window_size_x
		get_window().size.x = window_size_x
	
		get_viewport().size.y = window_size_y
		get_window().size.y = window_size_y
	
		# Get the current window
		var window = get_window()
		# And get the current screen the window's in
		var screen = window.current_screen
		# Get the usable rect for that screen
		var screen_rect = DisplayServer.screen_get_usable_rect(screen)
		# Get the window's size
		var window_size = window.get_size_with_decorations()
		# Set its position to the middle
		window.position = screen_rect.position + (screen_rect.size / 2 - window_size / 2)
