extends Node2D
class_name Puerta

@export var flipear_x: bool = false
@export var flipear_y: bool = false
@export var sprite_cerrado: Texture2D = preload("uid://0bgxx8p1bl2h")
@export var sprite_semi_abierto: Texture2D = preload("uid://dx8eypondavwd")
@export var sprite_abierto: Texture2D = preload("uid://cwyyqyryoernq")


func _process(_delta: float) -> void:
	if %ColisionAbierta.has_overlapping_bodies():
		%Sprite2D.texture = sprite_abierto
	elif %ColisionSemiAbierta.has_overlapping_bodies():
		%Sprite2D.texture = sprite_semi_abierto
	else:
		%Sprite2D.texture = sprite_cerrado
