extends VBoxContainer

func set_current_skill_mode():
	$CurrentAttackButton/Glow.visible = true
	$UpgradeAttackButton/Glow.visible = false
	$Button.release_focus()

func set_upgrade_skill_mode():
	$CurrentAttackButton/Glow.visible = false
	$UpgradeAttackButton/Glow.visible = true
	$Button.grab_focus()

func unfocus():
	$CurrentAttackButton/Glow.visible = false
	$UpgradeAttackButton/Glow.visible = false
	$Button.release_focus()
