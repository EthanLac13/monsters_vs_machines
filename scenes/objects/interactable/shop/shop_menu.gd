extends Control

func _ready() -> void:
	set_upgrade_mode()

func set_upgrade_mode():
	$MainScreen/UpgradesTab.position.y = -28.0
	$MainScreen/UpgradesTab.modulate = Color(1, 1, 1, 1)
	$MainScreen/TowersTab.position.y = -26.0
	$MainScreen/TowersTab.modulate = Color(0.5, 0.5, 0.5, 1)
