# This node handles dropping coins when an enemy is killed
extends Node2D

static var coin_scene: PackedScene = load("res://scenes/pickups/SmallCoin.tscn")

var coins_to_drop: int = 0


func drop_coins():
	for i in range(0, coins_to_drop):
		var my_coin_node = coin_scene.instantiate()
		get_parent().get_parent().add_child(my_coin_node)
		my_coin_node.position = get_parent().position
		my_coin_node.position.x += randf_range(-8, 8)
		my_coin_node.position.y += randf_range(-8, 8)
