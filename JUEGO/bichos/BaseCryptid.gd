extends RigidBody2D
class_name BaseCryptid


enum EstadoAlerta {VERDE, AMARILLO, NARANJA, ROJO, NEGRO}

@export var nombre = "DEFAULT"
@export var estado_alerta_inicial: EstadoAlerta = EstadoAlerta.VERDE
@export var estado_alerta_actual: EstadoAlerta = EstadoAlerta.VERDE
