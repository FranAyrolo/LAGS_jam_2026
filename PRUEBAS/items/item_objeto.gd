extends Node2D

@export var item_data: ItemUsable = preload("res://PRUEBAS/items/default.tres")

func _ready() -> void:
	$Sprite2D.texture = item_data.imagen


func _process(delta: float) -> void:
	pass
