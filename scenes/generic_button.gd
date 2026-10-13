extends NinePatchRect

var unpressed_texture: Texture2D = texture
@export var pressed_texture: Texture2D = load("res://sprites/hud_sprites/buttons/button_anysize_pressed.png")

func _ready() -> void:
	$Glow.size = size
	$Glow.visible = false

func press_down():
	texture = pressed_texture

func press_up():
	texture = unpressed_texture

func focus():
	$Glow.visible = true
func unfocus():
	$Glow.visible = false
