extends Control

var upgrade_box_scene: PackedScene = load("res://scenes/objects/interactable/shop/ShopMoveUpgradeBox.tscn")
var player: Node2D
var upgrade_boxes: Array[VBoxContainer] = []
var upgrade_text: Array[String] = []

# Whether we're viewing current skills or upgrading them
var upgrade_mode: bool = true

# Currently-selected skill
var current_skill: int = 0
# Previously-selected skill
var previous_skill: int = 0

var skill_text_path: String = "skill_text.json"
var skill_data = []
var skill_text = []
var skill_data_path_template: String = "res://data/skills/%s.json"

func _ready() -> void:
	skill_text = GeneralFunctions.load_translated_json_file(skill_text_path)
	player = get_tree().get_nodes_in_group("friendly_characters")[0]
	
	create_upgrade_boxes()
	set_upgrade_mode()
	focus_on_upgrade(current_skill)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("InputRight"):
		current_skill += 1
		if current_skill >= upgrade_boxes.size():
			current_skill -= 1
		focus_on_upgrade(current_skill)
	if Input.is_action_just_pressed("InputLeft"):
		current_skill -= 1
		if current_skill < 0:
			current_skill += 1
		focus_on_upgrade(current_skill)
	
	if Input.is_action_just_pressed("InputUp"):
		upgrade_mode = false
		focus_on_upgrade(current_skill)
	if Input.is_action_just_pressed("InputDown"):
		upgrade_mode = true
		focus_on_upgrade(current_skill)
		
	if Input.is_action_just_pressed("Interact"):
		if upgrade_mode:
			upgrade_boxes[current_skill].press_down()
	if Input.is_action_just_released("Interact"):
		if upgrade_mode:
			# Do stuff if we selected the upgrade
			if upgrade_boxes[current_skill].pressed_down:
				pass
			upgrade_boxes[current_skill].press_up()

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
	upgrade_boxes[previous_skill].unfocus()
	var individual_text = skill_text[player.skill_list[upgrade_index]]
	if upgrade_mode:
		upgrade_boxes[upgrade_index].set_upgrade_skill_mode()
		var upgrade_skill_text = skill_text[skill_data[upgrade_index].upgrades[0].upgrade_name]
		$MainScreen/UpgradeText.text = upgrade_skill_text.name + "\n" + upgrade_skill_text.upgrade_text
	else:
		upgrade_boxes[upgrade_index].set_current_skill_mode()
		$MainScreen/UpgradeText.text = individual_text.name + "\n" + individual_text.desc
	previous_skill = upgrade_index
