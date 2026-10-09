extends "res://scenes/characters/base_ai_controller.gd"

var shop_controller_scene: PackedScene = load("res://scenes/characters/misc/target_crystal/ShopController.tscn")

func initialize():
	super()
	# Don't display the mini health bar; we already have the full-length one on the GUI
	controlled_entity.get_node("HealthBar").visible = false
	
	# Create the zone that lets you enter the shop
	var my_shop_controller = shop_controller_scene.instantiate()
	controlled_entity.add_child(my_shop_controller)
	my_shop_controller.crystal_glow = controlled_entity.animation_object.anim_object.get_node("Crystal/Glow")
	my_shop_controller.player = player_entity

func _process(delta: float) -> void:
	super(delta)
			
