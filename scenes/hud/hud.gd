extends CanvasLayer

var player_node: Node2D
var crystal_node: Node2D

func _ready() -> void:
	# Scale is set to 0.5 by default, so it looks okay in the editor
	# Scale is reset to 1.0 in-game so it looks good there
	scale.x = 1.0
	scale.y = 1.0
	
	get_main_objects.call_deferred()

func get_main_objects():
	# Get player and crystal objects
	player_node = get_parent().get_node("Player")
	crystal_node = get_parent().get_node("TargetCrystal")
	print(crystal_node)
	
	crystal_node.took_damage.connect(update_crystal_hp)

# Updates the crystal HP bar at the bottom of the screen
func update_crystal_hp():
	$CrystalHealthBar.value = crystal_node.stats_data.hp / float(crystal_node.stats_data.max_hp)
