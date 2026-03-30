extends Node2D
class_name ControlMacetas

var puntos_por_estado: Dictionary[Maceta.EstadoMaceta, float] = {
	Maceta.EstadoMaceta.VIVA: 0.,
	Maceta.EstadoMaceta.MEDIO_VIVA: 1.,
	Maceta.EstadoMaceta.SECA: 2.
}
var macetas: Array[Node]
#Suma de cuan secas pueden estar todas las macetas juntas
var sequedad_maxima: float
var estado_general: float 


func _ready() -> void:
	macetas = get_children().filter(func(c): return c is Maceta)
	for m: Maceta in macetas:
		m.cambio_de_estado.connect(calcular_estado_general)
	sequedad_maxima = puntos_por_estado[Maceta.EstadoMaceta.SECA] * macetas.size()


func calcular_estado_general(_estado) -> void:
	$Label.text = "ESTADO GENERAL: %s" % estado_general
	#suma de la sequedad de todas las macetas
	var sequedad_actual: float = 0.
	for m: Maceta in macetas:
		sequedad_actual += puntos_por_estado[m.estado_maceta]
	
	#lo paso a porcentaje porque los criptidos miden de 0 a 100
	estado_general = sequedad_actual / sequedad_maxima * 100.


func reiniciar() -> void:
	for maceta: Maceta in macetas:
		maceta.reiniciar()
