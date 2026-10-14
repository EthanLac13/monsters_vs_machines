extends NinePatchRect

var unpressed_texture: Texture2D = texture
@export var pressed_texture: Texture2D = load("res://sprites/hud_sprites/buttons/button_anysize_pressed.png")
var pressed_down: bool = false

signal was_focused
signal was_pressed

func _ready() -> void:
	$Glow.size = size
	$Glow.visible = false

func press_down():
	if !pressed_down:
		texture = pressed_texture
		pressed_down = true
		$Label.position.y += 1
		$Glow.visible = false

func press_up():
	if pressed_down:
		texture = unpressed_texture
		pressed_down = false
		$Label.position.y -= 1
		was_pressed.emit()

func release():
	if pressed_down:
		$Label.position.y -= 1
	texture = unpressed_texture
	pressed_down = false
	$Glow.visible = false

func focus():
	$Glow.visible = true
	was_focused.emit()
func unfocus():
	$Glow.visible = false
