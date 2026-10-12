extends Control

var upgrade_box_scene: PackedScene = load("res://scenes/objects/interactable/shop/ShopMoveUpgradeBox.tscn")
var player: Node2D
var upgrade_boxes: Array[VBoxContainer] = []
var upgrade_text: Array[String] = []

var skill_text_path: String = "res://data/strings/skill_text.json"
var skill_data = []
var skill_text = []
var skill_data_path_template: String = "res://data/skills/%s.json"

func _ready() -> void:
	skill_text = GeneralFunctions.load_json_file(skill_text_path)
	player = get_tree().get_nodes_in_group("friendly_characters")[0]
	
	create_upgrade_boxes()
	set_upgrade_mode()
	focus_on_upgrade(0)

func set_upgrade_mode():
	$MainScreen/UpgradesTab.position.y = -28.0
	$MainScreen/UpgradesTab.modulate = Color(1, 1, 1, 1)
	$MainScreen/TowersTab.position.y = -26.0
	$MainScreen/TowersTab.modulate = Color(0.5, 0.5, 0.5, 1)

func create_upgrade_boxes():
	# Create upgrade boxes for player's unlocked skills
	for i in range(0, player.skill_list.size()):
		var my_upgrade_box = upgrade_box_scene.instantiate()
		$MainScreen/UpgradeContainer.add_child(my_upgrade_box)
		upgrade_boxes.append(my_upgrade_box)
		
		# Get upgrade text
		skill_data.append(GeneralFunctions.load_json_file(skill_data_path_template % player.skill_list[i]))
	
	# Create upgrade boxes for the skills you can purchase
	# TODO
	

# Set focus on an upgrade box
func focus_on_upgrade(upgrade_index: int):
	upgrade_boxes[upgrade_index].get_node("Button").grab_focus()
	var individual_text = skill_text[player.skill_list[upgrade_index]]
	$MainScreen/UpgradeText.text = individual_text.name + "\n" + individual_text.desc
