extends Node2D

var criptidos
@export var curupira: Curupira

func _ready() -> void:
	criptidos = %Criptidos.get_children().filter(
		func(c): return c is BaseCryptid
	)
	curupira.cambio_de_estado.connect(actualizar_curupira)


func actualizar_curupira(estado: BaseCryptid.EstadoAlerta) -> void:
	match estado:
		BaseCryptid.EstadoAlerta.VERDE:
			$SpriteCurupira.modulate = Color.GREEN
		BaseCryptid.EstadoAlerta.AMARILLO:
			$SpriteCurupira.modulate = Color.YELLOW
		BaseCryptid.EstadoAlerta.NARANJA:
			$SpriteCurupira.modulate = Color.CORAL
		BaseCryptid.EstadoAlerta.ROJO:
			$SpriteCurupira.modulate = Color.RED
		
