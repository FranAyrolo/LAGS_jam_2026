extends Node2D
class_name DepositoDeObjetos

@export var texto_deposito_vacio: String = "Deposite coso aqui"
@export var imagen: Texture2D = null
@export var objetos_aceptables: Array = []
@export var retener_objeto: bool = false
var objeto_depositado: ObjetoItem = null


func _ready() -> void:
	if imagen:
		$Sprite2D.texture = imagen
	objetos_aceptables = objetos_aceptables.map(func(e: String): return e.to_lower()) as Array[String]
	$Area2D.body_shape_entered.connect(_on_body_shape_entered)


func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is ObjetoItem:
		if body.item_data.nombre.to_lower() in objetos_aceptables:
			print("ACEPTO " + body.item_data.nombre + "s, lo tomo")
			body.reparent(self)
			objeto_depositado = body
			objeto_depositado.ser_juntado()
			$Label.text = objeto_depositado.item_data.nombre + " depositado"
			
		else:
			$Label.text = "Objeto incorrecto"
			get_tree().create_timer(1).timeout.connect(restablecer_mensajito)


func agregar_objeto_aceptable(obj: String) -> void:
	if obj.to_lower() not in objetos_aceptables:
		objetos_aceptables.append(obj.to_lower())


func eliminar_objeto_aceptable(obj: String) -> void:
	objetos_aceptables.erase(obj.to_lower())


func es_aceptable(obj: String) -> bool:
	return obj.to_lower() in objetos_aceptables


func restablecer_mensajito() -> void:
	$Label.text = texto_deposito_vacio
