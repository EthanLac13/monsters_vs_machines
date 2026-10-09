extends Node2D

var active: bool = false
var player: Node2D
var crystal_glow: Sprite2D
var crystal_fade_amount: float = 0.05

func _process(delta: float) -> void:
	if active:
		if crystal_glow.modulate.a < 1.0:
			crystal_glow.modulate.a += crystal_fade_amount
			$Tooltip.modulate.a += crystal_fade_amount
	else:
		if crystal_glow.modulate.a > 0.0:
			crystal_glow.modulate.a -= crystal_fade_amount
			$Tooltip.modulate.a -= crystal_fade_amount
	
	$Tooltip.global_position.x = player.global_position.x - 24
	$Tooltip.global_position.y = player.global_position.y - 40

func _on_shop_entry_area_area_entered(area: Area2D) -> void:
	active = true

func _on_shop_entry_area_area_exited(area: Area2D) -> void:
	active = false
