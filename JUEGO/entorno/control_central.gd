extends Node2D

signal fin_de_juego_derrota

var criptidos
@export var curupira: Curupira
@export var pomberito: BaseCryptid
@export var sombreron: BaseCryptid

func _ready() -> void:
	criptidos = %Criptidos.get_children().filter(
		func(c): return c is BaseCryptid
	)
	curupira.cambio_de_estado.connect(actualizar_curupira)
	pomberito.cambio_de_estado.connect(actualizar_pomberito)
	sombreron.cambio_de_estado.connect(actualizar_sombreron)


func checkear_alerta_negra() -> void:
	for criptido: BaseCryptid in criptidos:
		if criptido.estado_alerta_actual == BaseCryptid.EstadoAlerta.NEGRO:
			fin_de_juego_derrota.emit()

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
	checkear_alerta_negra()


func actualizar_pomberito(estado: BaseCryptid.EstadoAlerta) -> void:
	match estado:
		BaseCryptid.EstadoAlerta.VERDE:
			$SpritePomberito.modulate = Color.GREEN
		BaseCryptid.EstadoAlerta.AMARILLO:
			$SpritePomberito.modulate = Color.YELLOW
		BaseCryptid.EstadoAlerta.NARANJA:
			$SpritePomberito.modulate = Color.CORAL
		BaseCryptid.EstadoAlerta.ROJO:
			$SpritePomberito.modulate = Color.RED


func actualizar_sombreron(estado: BaseCryptid.EstadoAlerta) -> void:
	match estado:
		BaseCryptid.EstadoAlerta.VERDE:
			$SpriteSombreron.modulate = Color.GREEN
		BaseCryptid.EstadoAlerta.AMARILLO:
			$SpriteSombreron.modulate = Color.YELLOW
		BaseCryptid.EstadoAlerta.NARANJA:
			$SpriteSombreron.modulate = Color.CORAL
		BaseCryptid.EstadoAlerta.ROJO:
			$SpriteSombreron.modulate = Color.RED


func _on_pomberito_se_escapo_uno(nombre: Variant) -> void:
	checkear_alerta_negra()


func _on_sombreron_se_escapo_uno(nombre: Variant) -> void:
	checkear_alerta_negra()

func reiniciar() -> void:
	$SpriteCurupira.modulate = Color.GREEN
	$SpritePomberito.modulate = Color.GREEN
	$SpriteSombreron.modulate = Color.GREEN
