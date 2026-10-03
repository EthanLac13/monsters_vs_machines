extends Node2D

@export var ai_script: GDScript

# Track chasing
@export var crystal_chase_dir: float = 128.0 ## How far away we need to be from the player to chase the crystal
@export var next_node_dir: float = 24.0 ## How close we need to get to the current track node to move to the next

# Stats
@export var health: int = 0 ## Entity's max HP
@export var attack: int = 0 ## Entity's physical attack power; can be modified by individual attacks
@export var defense: int = 0 ## Entity's physical defense; subtracted from incoming physical attacks
@export var magic_attack: int = 0 ## Entity's elemental attack power; can be modified by individual attacks
@export var magic_defense: int = 0 ## Entity's elemental defense; subtracted from incoming elemental attacks
@export var movement_speed: float = 0 ## How fast the entity moves, in pixels per frame

# Other qualities
@export var weight: float = 10.0 ## Affects how far the entity is knocked back. Set to -1 to make it still play the pain anim, but not move.
@export var can_flinch: bool = true ## Controls whether the entity can flinch from attacks
