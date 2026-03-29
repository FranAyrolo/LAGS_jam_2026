extends ObjetoInteractuableFijo
class_name Maceta

signal cambio_de_estado(nuevo_estado: EstadoMaceta)
enum EstadoMaceta {VIVA, MEDIO_VIVA, SECA}
@export var tex_viva: Texture2D
@export var tex_medio_viva: Texture2D
@export var tex_reseca: Texture2D
@export var temporizador: float = 2.
@export var decrecimiento_por_paso: float = 5.
@export var azarcito: float = .2
var nivel_vital: float = 100
var estado_maceta: EstadoMaceta = EstadoMaceta.VIVA


func _ready() -> void:
	$Sprite2D.texture = tex_viva
	$Timer.wait_time = temporizador
	$Timer.timeout.connect(resecarse)


func resecarse() -> void:
	nivel_vital = clamp(nivel_vital - decrecimiento_por_paso * (1 + randf_range(-azarcito, azarcito)), 0., 100.)
	update_estado()
	update_sprite()


func interactuar() -> void:
	pass


func update_estado() -> void:
	if nivel_vital <= 33.3:
		if estado_maceta != EstadoMaceta.SECA:
			estado_maceta = EstadoMaceta
			cambio_de_estado.emit(estado_maceta)
	elif nivel_vital <= 66.6:
		if estado_maceta != EstadoMaceta.MEDIO_VIVA:
			estado_maceta = EstadoMaceta.MEDIO_VIVA
			cambio_de_estado.emit(estado_maceta)
	else:
		if estado_maceta != EstadoMaceta.VIVA:
			estado_maceta = EstadoMaceta.VIVA
			cambio_de_estado.emit(estado_maceta)


func update_sprite() -> void:
	match estado_maceta:
		EstadoMaceta.VIVA:
			$Sprite2D.texture = tex_viva
		EstadoMaceta.MEDIO_VIVA:
			$Sprite2D.texture = tex_medio_viva
		EstadoMaceta.SECA:
			$Sprite2D.texture = tex_reseca
		_:
			push_error("WTF de maceta")
