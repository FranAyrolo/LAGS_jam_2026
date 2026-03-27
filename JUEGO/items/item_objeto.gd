extends RigidBody2D
class_name ObjetoItem

@export var item_data: ItemResource = preload("uid://ckwg84eo3kmi2")

func _ready() -> void:
	$Sprite2D.texture = item_data.imagen
	%EtiquetaNombre.text = item_data.nombre


func _process(_delta: float) -> void:
	%EtiquetaNombre.visible = %DetectorProximidad.has_overlapping_bodies()
	#if Input.is_action_just_pressed("INPUT_ITEM") and %DetectorProximidad.has_overlapping_bodies():
		#Global.item_seleccionado.emit(item_data, self)


func ser_juntado() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	#%DetectorProximidad.process_mode = Node.PROCESS_MODE_DISABLED
	%EtiquetaNombre.text = ""


func ser_puesto_en_el_piso() -> void:
	%EtiquetaNombre.text = item_data.nombre
	await get_tree().create_timer(.15).timeout
	#%DetectorProximidad.process_mode = Node.PROCESS_MODE_INHERIT
	process_mode = Node.PROCESS_MODE_INHERIT
	apply_central_force(Vector2(.1, .1))
