extends Node2D

var criptidos: Array = []  # register all cryptids here
const PESOS = {
	BaseCryptid.CryptidType.POMBERO: 30,
	BaseCryptid.CryptidType.CARPINCHO: 10,
	BaseCryptid.CryptidType.SILBON: 20,
	BaseCryptid.CryptidType.SOMBRERON: 15,
	BaseCryptid.CryptidType.CURUPIRA: 15,
	BaseCryptid.CryptidType.CHUPACABRAS: 25,
	BaseCryptid.CryptidType.CADEJO: 20,
	BaseCryptid.CryptidType.LLORONA: 20,
	BaseCryptid.CryptidType.LUZ_MALA: 15,
	BaseCryptid.CryptidType.MANDINGA: 30,
}


func registrar_criptido(cryptid) -> void:
	criptidos.append(cryptid)

func remover_criptido(cryptid) -> void:
	criptidos.erase(cryptid)

func elegir_criptido_pesado():
	if criptidos.is_empty():
		return null
	var total = 0
	for criptido in criptidos:
		total += PESOS.get(criptido.nombre, 1)
	var roll = randi() % total
	var acumulado = 0
	for criptido in criptidos:
		acumulado += PESOS.get(criptido.nombre, 1)
		if roll < acumulado:
			return criptido
	return criptidos[-1]

func _on_criptido_timer_timeout() -> void:
	var elegido = elegir_criptido_pesado()
	if elegido:
		elegido.incrementar_contador(1)
	elegido.revisar_puntaje()
