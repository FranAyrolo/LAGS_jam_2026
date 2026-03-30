extends RigidBody2D
class_name BaseCryptid

signal cambio_de_estado(nuevo_estado: EstadoAlerta)
signal se_escapo_uno(nombre)

enum CryptidType {DEFAULT, CARPINCHO, POMBERO, SOMBRERON, CURUPIRA, 
					SILBON, CHUPACABRAS, CADEJO, LLORONA, LUZ_MALA, MANDINGA}
enum EstadoAlerta {VERDE, AMARILLO, NARANJA, ROJO, NEGRO}

@export var nombre: CryptidType = CryptidType.DEFAULT
@export var estado_alerta_inicial: EstadoAlerta = EstadoAlerta.VERDE
@export var estado_alerta_actual: EstadoAlerta = EstadoAlerta.VERDE
@export var movement_speed: float = 750
@export var estado_score_track: float = 0.
@export var criptido_activo: bool = false

@onready var navigation_agent: NavigationAgent2D = get_node_or_null("NavigationAgent2D")

const MAX_SCORE = 100
const MIN_SCORE = 0
@onready var Criptidos = %Criptidos

func reiniciar_alerta() -> void:
	estado_alerta_actual = estado_alerta_inicial
	estado_score_track = 0
	Global.cryptido_alerta_reiniciada.emit(self)
	print("ME CORTE EL PELO", estado_alerta_actual,estado_score_track)

	
func incrementar_contador(amount: int) -> void:
	estado_score_track = clamp(estado_score_track + amount, MIN_SCORE, MAX_SCORE)

func reducir_contador(amount: int) -> void:
	estado_score_track = clamp(estado_score_track - amount, MIN_SCORE, MAX_SCORE)

func activar_criptido() -> void:
	Criptidos.registrar_criptido(self)
	
func revisar_puntaje() -> void:
	var nuevo_estado = calcular_estado()
	if nuevo_estado != estado_alerta_actual:
		estado_alerta_actual = nuevo_estado
		cambio_de_estado.emit(estado_alerta_actual)
		estado_cambiado(estado_alerta_actual)
		#print("Cambio el estado a ",estado_alerta_actual)

func calcular_estado() -> EstadoAlerta:
	if estado_score_track < 25:   
		return EstadoAlerta.VERDE
	elif estado_score_track < 50: 
		return EstadoAlerta.AMARILLO
	elif estado_score_track < 75: 
		return EstadoAlerta.NARANJA
	elif estado_score_track < 95: 
		return EstadoAlerta.ROJO
	elif estado_score_track < 100: 
		return EstadoAlerta.NEGRO
	else:
		se_escapo_uno.emit(estado_alerta_actual)
		return EstadoAlerta.NEGRO
				

func estado_cambiado(_nuevo_estado: EstadoAlerta) -> void:
	pass


func reiniciar() -> void:
	pass
