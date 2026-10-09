# This node handles dropping coins when an enemy is killed
extends Node2D

static var coin_scene: PackedScene = load("res://scenes/pickups/SmallCoin.tscn")

var coins_to_drop: int = 0


func drop_coins():
	var dropped_coins: Array[Node2D] = []
	var current_coin: int = -1
	
	for i in range(0, coins_to_drop):
		if current_coin == -1:
			var my_coin_node = coin_scene.instantiate()
			get_parent().get_parent().add_child(my_coin_node)
			dropped_coins.append(my_coin_node)
			my_coin_node.position = get_parent().position
			my_coin_node.position.x += randf_range(-8, 8)
			my_coin_node.position.y += randf_range(-8, 8)
		else:
			dropped_coins[current_coin].value += 1
			
		current_coin += 1
		if current_coin >= dropped_coins.size():
			current_coin = -1
