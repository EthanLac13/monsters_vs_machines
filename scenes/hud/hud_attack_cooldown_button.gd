extends TextureRect

var my_progress_bar: TextureProgressBar

func _ready() -> void:
	my_progress_bar = $ProgressBar
	set_progress(0.0)

func set_progress(progress: float):
	my_progress_bar.value = progress
