extends Area2D
class_name DepositoDeObjetos

@export var texto_deposito_vacio: String = "Deposite coso aqui"
@export var imagen: Texture2D = null
@export var objetos_aceptables: Array = []
@export var retener_objeto: bool = false

var objeto_depositado: ObjetoItem = null
var flag_rebote_objeto: bool = true


func _ready() -> void:
	$Timer.timeout.connect(_levantar_flag_rebote)
	if imagen:
		$Sprite2D.texture = imagen
	objetos_aceptables = objetos_aceptables.map(func(e: String): return e.to_lower()) as Array[String]


func recibir_objeto(objeto: ObjetoItem) -> bool:
	bajar_flag_rebote()
	if es_aceptable(objeto) && objeto_depositado == null:
		print("ACEPTO " + objeto.item_data.nombre + "s, lo tomo")
		objeto.reparent(self)
		objeto_depositado = objeto
		$Label.text = objeto_depositado.item_data.nombre + " depositado"
		objeto_depositado.ser_juntado()
		return true
	elif !es_aceptable(objeto) && objeto_depositado == null:
		$Label.text = "Objeto incorrecto"
		get_tree().create_timer(1).timeout.connect(restablecer_mensajito)
	return false


func soltar_objeto() -> ObjetoItem:
	var obj: ObjetoItem = null
	bajar_flag_rebote()
	if objeto_depositado && !retener_objeto:
		$Label.text = ""
		obj = objeto_depositado
		objeto_depositado.ser_puesto_en_el_piso()
		objeto_depositado = null
	
	return obj


func consumir_objeto() -> bool:
	if objeto_depositado:
		objeto_depositado.queue_free()
		objeto_depositado = null
		return true
	return false


func agregar_objeto_aceptable(obj: String) -> void:
	if obj.to_lower() not in objetos_aceptables:
		objetos_aceptables.append(obj.to_lower())


func eliminar_objeto_aceptable(obj: String) -> void:
	objetos_aceptables.erase(obj.to_lower())


func es_aceptable(obj: ObjetoItem) -> bool:
	return obj.item_data.nombre.to_lower() in objetos_aceptables


func bajar_flag_rebote() -> void:
	flag_rebote_objeto = false
	$Timer.start()


func _levantar_flag_rebote() -> void:
	flag_rebote_objeto = true


func restablecer_mensajito() -> void:
	if objeto_depositado:
		$Label.text = objeto_depositado.item_data.nombre + " depositado"
	else:
		$Label.text = texto_deposito_vacio
