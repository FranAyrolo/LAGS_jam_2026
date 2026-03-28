extends RigidBody2D
class_name BaseCryptid

enum CryptidType {DEFAULT, CARPINCHO, POMBERO, SOMBRERON, CURUPIRA, 
					SILBON, CHUPACABRAS, CADEJO, LLORONA, LUZ_MALA, MANDINGA}
enum EstadoAlerta {VERDE, AMARILLO, NARANJA, ROJO, NEGRO}

@export var nombre: CryptidType = CryptidType.DEFAULT
@export var estado_alerta_inicial: EstadoAlerta = EstadoAlerta.VERDE
@export var estado_alerta_actual: EstadoAlerta = EstadoAlerta.VERDE
@export var movement_speed: float = 750

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

#fue, la hago cabeza porque hacerlo bonito esta complicado
func aumentar_alerta() -> void:
	if estado_alerta_actual != EstadoAlerta.NEGRO:
		match estado_alerta_actual:
			EstadoAlerta.VERDE:
				estado_alerta_actual = EstadoAlerta.AMARILLO
			EstadoAlerta.AMARILLO:
				estado_alerta_actual = EstadoAlerta.NARANJA
			EstadoAlerta.NARANJA:
				estado_alerta_actual = EstadoAlerta.ROJO
			EstadoAlerta.ROJO:
				estado_alerta_actual = EstadoAlerta.NEGRO
				Global.cryptido_en_negro.emit(self)
			_:
				push_error("MMMMMM, en que estado estamo?")


#fue, la hago cabeza porque hacerlo bonito esta complicado
func reducir_alerta() -> void:
	if estado_alerta_actual != EstadoAlerta.VERDE:
		match estado_alerta_actual:
			EstadoAlerta.VERDE:
				pass
			EstadoAlerta.AMARILLO:
				estado_alerta_actual = EstadoAlerta.VERDE
			EstadoAlerta.NARANJA:
				estado_alerta_actual = EstadoAlerta.AMARILLO
			EstadoAlerta.ROJO:
				estado_alerta_actual = EstadoAlerta.NARANJA
			#EstadoAlerta.NEGRO:
				#estado_alerta_actual = EstadoAlerta.NARANJA
			_:
				push_error("MMMMMM, en que estado estamo?")


func reiniciar_alerta() -> void:
	estado_alerta_actual = estado_alerta_inicial
	Global.cryptido_alerta_reiniciada.emit(self)
