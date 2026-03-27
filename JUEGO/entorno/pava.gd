extends ObjetoInteractuableFijo
class_name Pava

@export var carga_de_agua: float = 1.

func interactuar() -> void:
	Global.cargar_termo.emit(carga_de_agua)
