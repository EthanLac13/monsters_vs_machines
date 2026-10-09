extends CanvasLayer

var player_node: Node2D
var crystal_node: Node2D

var skill_buttons: Array[TextureRect]
var wave_hud: Array[Control]

var gauge_text_template: String = "%d/%d"

func _ready() -> void:
	# Scale is set to 0.5 by default, so it looks okay in the editor
	# Scale is reset to 1.0 in-game so it looks good there
	scale.x = 1.0
	scale.y = 1.0
	
	skill_buttons = [
		$AttackCooldownButton1,
		$AttackCooldownButton2,
		$AttackCooldownButton3,
		$AttackCooldownButton4
	]
	wave_hud = [
		$WaveFlag,
		$WaveText,
		$EnemyCountIcon,
		$EnemyCountText
	]
	hide_wave_hud()
	
	get_main_objects.call_deferred()

func get_main_objects():
	# Get player and crystal objects
	player_node = get_parent().get_node("Player")
	crystal_node = get_parent().get_node("TargetCrystal")
	#print(crystal_node)
	
	crystal_node.took_damage.connect(update_crystal_hp)

# Set the cooldown of a player skill
func set_skill_cooldown(skill_index: int, cooldown: float):
	skill_buttons[skill_index].set_progress(cooldown)

# Updates the crystal HP bar at the bottom of the screen
func update_crystal_hp():
	$CrystalHealthBar.value = crystal_node.stats_data.hp / float(crystal_node.stats_data.max_hp)

# Updates the player's HP
func update_health_bar(current_hp: float, max_hp: float):
	$HPText.text = gauge_text_template % [current_hp, max_hp]
	$HPBar.value = current_hp / max_hp

# Updates the player's EXP
func update_exp_bar(current_exp: float, exp_to_max: float):
	$EXPText.text = gauge_text_template % [current_exp, exp_to_max]
	$EXPBar.value = current_exp / exp_to_max

# Updates the player's level
func update_level(current_level: int):
	$LevelText.text = str(current_level)

# Updates the money count
func update_money(new_money: int):
	$MoneyText.text = " " + str(new_money)


# Shows the wave and enemy count
func show_wave_hud():
	for wave_hud_element in wave_hud:
		wave_hud_element.visible = true

# Hides the wave and enemy count
func hide_wave_hud():
	for wave_hud_element in wave_hud:
		wave_hud_element.visible = false

# Sets wave text
func set_wave_text(current_wave: int):
	$WaveText.text = " " + str(current_wave)

# Sets enemy count
func set_enemy_count(enemies: int):
	$EnemyCountText.text = str(enemies) + " "
