extends VBoxContainer

var unlocked: bool = true
var pressed_down: bool = false

static var unlock_button_unpressed_texture: Texture2D = load("res://sprites/shop_sprites/unlock_button.png")
static var unlock_button_pressed_texture: Texture2D = load("res://sprites/shop_sprites/unlock_button_pressed.png")

static var upgrade_button_unpressed_texture: Texture2D = load("res://sprites/shop_sprites/upgrade_button.png")
static var upgrade_button_pressed_texture: Texture2D = load("res://sprites/shop_sprites/upgrade_button_pressed.png")

var button_unpressed_texture
var button_pressed_texture

func _ready() -> void:
	if unlocked:
		button_unpressed_texture = upgrade_button_unpressed_texture
		button_pressed_texture = upgrade_button_pressed_texture
	else:
		button_unpressed_texture = unlock_button_unpressed_texture
		button_pressed_texture = unlock_button_pressed_texture
		
		# Initially, hide the upgrade progression
		$UpgradeAttackButton.modulate.a = 0.0
		$Arrow.modulate.a = 0.0
		$CurrentAttackButton.modulate = Color(0.5, 0.5, 0.5)
	$Button.texture = button_unpressed_texture

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
