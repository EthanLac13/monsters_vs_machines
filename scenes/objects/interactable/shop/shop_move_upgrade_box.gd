extends VBoxContainer

var pressed_down: bool = false

var button_unpressed_texture: Texture2D = load("res://sprites/shop_sprites/upgrade_button.png")
var button_pressed_texture: Texture2D = load("res://sprites/shop_sprites/upgrade_button_pressed.png")

func set_current_skill_mode():
	$CurrentAttackButton/Glow.visible = true
	$Button/Glow.visible = false
	press_up()

func set_upgrade_skill_mode():
	$CurrentAttackButton/Glow.visible = false
	$Button/Glow.visible = true
	press_up()

func unfocus():
	$CurrentAttackButton/Glow.visible = false
	$Button/Glow.visible = false
	press_up()

func press_down():
	$Button.texture = button_pressed_texture
	$Button/Glow.visible = false
	pressed_down = true
func press_up():
	$Button.texture = button_unpressed_texture
	pressed_down = false
