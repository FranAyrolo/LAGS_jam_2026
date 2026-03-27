extends Node2D

@export var item_data: ItemResource = preload("res://PRUEBAS/items/default.tres")

func _ready() -> void:
	$Sprite2D.texture = item_data.imagen
	%EtiquetaNombre.text = item_data.nombre


func _process(delta: float) -> void:
	%EtiquetaNombre.visible = %DetectorProximidad.has_overlapping_bodies()
	if Input.is_action_just_pressed("INPUT_INTERACT") and %DetectorProximidad.has_overlapping_bodies():
		Global.item_seleccionado.emit(item_data)
