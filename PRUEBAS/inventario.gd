extends Control

var item_data: ItemResource = null


func _ready() -> void:
	$TextureRect.texture = null
	$Label.text = "Inventario"


func agregar_item(item: ItemResource) -> void:
	item_data = item
	$TextureRect.texture = item_data.imagen
	$Label.text = item_data.nombre


func retirar_item() -> ItemResource:
	$TextureRect.texture = null
	$Label.text = "Inventario"
	return item_data


#Por ahora el jugador solo puede llevar un item a la vez en la mano, 
#sino esto pasa a ser una lista y se checkea toda
func tiene_item(_nombre: String) -> bool:
	return item_data.nombre == _nombre
