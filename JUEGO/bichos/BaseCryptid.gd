extends RigidBody2D
class_name BaseCryptid

signal cambio_de_estado(nuevo_estado: EstadoAlerta)

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

#fue, la hago cabeza porque hacerlo bonito esta complicado
#func aumentar_alerta() -> void:
	#if estado_alerta_actual != EstadoAlerta.NEGRO:
		#match estado_alerta_actual:
			#EstadoAlerta.VERDE:
				#estado_alerta_actual = EstadoAlerta.AMARILLO
			#EstadoAlerta.AMARILLO:
				#estado_alerta_actual = EstadoAlerta.NARANJA
			#EstadoAlerta.NARANJA:
				#estado_alerta_actual = EstadoAlerta.ROJO
			#EstadoAlerta.ROJO:
				#estado_alerta_actual = EstadoAlerta.NEGRO
				#Global.cryptido_en_negro.emit(self)
			#_:
				#push_error("MMMMMM, en que estado estamo?")
	#estado_cambiado(estado_alerta_actual)

#fue, la hago cabeza porque hacerlo bonito esta complicado
#func reducir_alerta() -> void:
	#if estado_alerta_actual != EstadoAlerta.VERDE:
		#match estado_alerta_actual:
			#EstadoAlerta.VERDE:
				#pass
			#EstadoAlerta.AMARILLO:
				#estado_alerta_actual = EstadoAlerta.VERDE
			#EstadoAlerta.NARANJA:
				#estado_alerta_actual = EstadoAlerta.AMARILLO
			#EstadoAlerta.ROJO:
				#estado_alerta_actual = EstadoAlerta.NARANJA
			##EstadoAlerta.NEGRO:
				##estado_alerta_actual = EstadoAlerta.NARANJA
			#_:
				#push_error("MMMMMM, en que estado estamo?")

func reiniciar_alerta() -> void:
	estado_alerta_actual = estado_alerta_inicial
	Global.cryptido_alerta_reiniciada.emit(self)
	
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
	elif estado_score_track < 100: 
		return EstadoAlerta.ROJO
	else:                          
		return EstadoAlerta.NEGRO


func estado_cambiado(nuevo_estado: EstadoAlerta) -> void:
	pass
