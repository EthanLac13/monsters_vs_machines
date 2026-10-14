extends Control

var state: int = 1

var my_wave_spawner: Node2D

var top_menu_option: int = 0
var current_button: NinePatchRect

var upgrade_box_scene: PackedScene = load("res://scenes/objects/interactable/shop/ShopMoveUpgradeBox.tscn")
var player: Node2D
var upgrade_boxes: Array[VBoxContainer] = []
var upgrade_text: Array[String] = []

# Whether we're viewing current skills or upgrading them
var upgrade_mode: bool = false

# Currently-selected skill
var current_skill: int = 0
# Previously-selected skill
var previous_skill: int = 0

var skill_text_path: String = "skill_text.json"
var skill_indexes: Array[String] = []
var skill_data = []
var skill_text = []
var skill_data_path_template: String = "res://data/skills/%s.json"

# Strings used for upgrade display
var unlock_template_string: String = StringData.strings["shop_unlock_preview"]
var unlock_template_no_money_string: String = StringData.strings["shop_unlock_preview_no_money"]
var upgrade_template_string: String = StringData.strings["shop_upgrade_preview"]
var upgrade_template_no_money_string: String = StringData.strings["shop_upgrade_preview_no_money"]

func _ready() -> void:
	skill_text = GeneralFunctions.load_translated_json_file(skill_text_path)
	player = get_tree().get_nodes_in_group("friendly_characters")[0]
	my_wave_spawner = get_tree().get_nodes_in_group("wave_spawners")[0]
	
	current_button = $MainScreen/NextWaveButton
	
	$MainScreen/NextWaveButton.was_focused.connect(show_start_wave_text)
	$MainScreen/NextWaveButton.was_pressed.connect(start_next_wave)
	$MainScreen/ExitButton.was_focused.connect(show_exit_text)
	$MainScreen/ExitButton.was_pressed.connect(exit_menu)
	
	create_upgrade_boxes()
	set_upgrade_mode()
	focus_on_upgrade(current_skill)

func _input(event: InputEvent) -> void:
	match state:
		0: # Next wave or exit flow
			if Input.is_action_just_pressed("InputRight"):
				current_button.release()
				current_button = $MainScreen/ExitButton
				current_button.focus()
			if Input.is_action_just_pressed("InputLeft"):
				current_button.release()
				current_button = $MainScreen/NextWaveButton
				current_button.focus()
			
			if Input.is_action_just_pressed("InputDown"):
				state = 1
				upgrade_boxes[current_skill].set_current_skill_mode()
				focus_on_upgrade(current_skill)
				$MainScreen/NextWaveButton.unfocus()
				$MainScreen/ExitButton.unfocus()
			
			if Input.is_action_just_pressed("Interact"):
				current_button.press_down()
			
			if Input.is_action_just_released("Interact"):
				current_button.press_up()
		
		1: # Upgrade/unlock flow
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
				if upgrade_mode && upgrade_boxes[current_skill].unlocked:
					upgrade_mode = false
					focus_on_upgrade(current_skill)
				else:
					state = 0
					upgrade_boxes[current_skill].unfocus()
					current_button = $MainScreen/NextWaveButton
					current_button.focus()
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
						if upgrade_boxes[current_skill].unlocked:
							# Get the name of the upgraded skill
							var next_skill_name: String = skill_data[current_skill].upgrades[0].upgrade_name
							
							# Set the skill list
							player.skill_list[current_skill] = next_skill_name
							skill_indexes[current_skill] = next_skill_name
							
							# Sets the skill data
							skill_data[current_skill] = GeneralFunctions.load_json_file(skill_data_path_template % next_skill_name)
							
							# Set the player's skill scenes and cooldowns
							player.refresh_skills()
							
							# Highlight the new skill
							upgrade_mode = false
							focus_on_upgrade(current_skill)
						
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
		skill_indexes.append(player.skill_list[i])
		
		# Get upgrade text
		skill_data.append(GeneralFunctions.load_json_file(skill_data_path_template % player.skill_list[i]))
	
	# Create upgrade boxes for the skills you can purchase
	# TODO
	for i in range(0, player.potential_skills.size()):
		var my_upgrade_box = upgrade_box_scene.instantiate()
		my_upgrade_box.unlocked = false
		$MainScreen/UpgradeContainer.add_child(my_upgrade_box)
		upgrade_boxes.append(my_upgrade_box)
		skill_indexes.append(player.potential_skills[i])
		
		# Get upgrade text
		skill_data.append(GeneralFunctions.load_json_file(skill_data_path_template % player.potential_skills[i]))
	

# Set focus on an upgrade box
func focus_on_upgrade(upgrade_index: int):
	if !upgrade_mode:
		if !upgrade_boxes[upgrade_index].unlocked:
			upgrade_mode = true
	
	upgrade_boxes[previous_skill].unfocus()
	print(skill_indexes[upgrade_index])
	var individual_text = skill_text[skill_indexes[upgrade_index]]
		
	if upgrade_mode:
		upgrade_boxes[upgrade_index].set_upgrade_skill_mode()
		if upgrade_boxes[upgrade_index].unlocked: # Show upgrade text if we can upgrade the skill
			var upgrade_skill_text = skill_text[skill_data[upgrade_index].upgrades[0].upgrade_name]
			var upgrade_cost: int = skill_data[upgrade_index].upgrades[0].cost
			var upgrade_header_string: String = upgrade_template_string
			if player.ai_controller.player_money < upgrade_cost:
				upgrade_header_string = upgrade_template_no_money_string
			$MainScreen/UpgradeText.text = (upgrade_header_string % [upgrade_cost, individual_text.name]) + "\n" + upgrade_skill_text.upgrade_text
		else: # Show unlock text if we can unlock the skill
			var unlock_cost: int = skill_data[upgrade_index].unlock_cost
			var unlock_header_string: String = unlock_template_string
			if player.ai_controller.player_money < unlock_cost:
				unlock_header_string = unlock_template_no_money_string
			$MainScreen/UpgradeText.text = (unlock_header_string % [unlock_cost, individual_text.name]) + "\n" + individual_text.desc
	else:
		upgrade_boxes[upgrade_index].set_current_skill_mode()
		$MainScreen/UpgradeText.text = individual_text.name + "\n" + individual_text.desc
	previous_skill = upgrade_index

# Shows wave start text
func show_start_wave_text():
	$MainScreen/UpgradeText.text = StringData.strings["shop_next_wave_text"] % [my_wave_spawner.wave + 1, my_wave_spawner.max_wave]
# Show exit text
func show_exit_text():
	$MainScreen/UpgradeText.text = StringData.strings["shop_exit_text"]

# Starts the next wave
func start_next_wave():
	my_wave_spawner.start_wave()
	exit_menu()

# Exits the menu
func exit_menu():
	get_tree().paused = false
	queue_free()
