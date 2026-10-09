extends "res://scenes/objects/interactable/interactable_object.gd"

var active: bool = false
var shop_open: bool = false
var player: Node2D
var crystal_glow: Sprite2D
var crystal_fade_amount: float = 0.05

var shop_menu_scene: PackedScene = load("res://scenes/objects/interactable/shop/ShopMenu.tscn")

func _ready() -> void:
	$Tooltip.modulate.a = 0.0

func _process(delta: float) -> void:
	if active:
		if crystal_glow.modulate.a < 1.0:
			crystal_glow.modulate.a += crystal_fade_amount
			$Tooltip.modulate.a += crystal_fade_amount
	else:
		if crystal_glow.modulate.a > 0.0:
			crystal_glow.modulate.a -= crystal_fade_amount
			$Tooltip.modulate.a -= crystal_fade_amount
	
	$Tooltip.global_position.x = player.global_position.x - 32
	$Tooltip.global_position.y = player.global_position.y - 40

func set_interactable():
	super()
	active = true

func set_not_interactable():
	super()
	active = false

func interact():
	super()
	
	var my_shop_ui = shop_menu_scene.instantiate()
	player.ai_controller.hud.add_child(my_shop_ui)
	get_tree().paused = true
	
	#my_shop_ui.scale.x = 0.5
	#my_shop_ui.scale.y = 0.5
