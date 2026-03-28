extends BaseCryptid
class_name Capibarus


var navigation_map_rid: RID
var tiene_mate: bool = false
var mate_lleno: bool = true
var seguir_jugador: bool = false
var jugador_en_navmesh: bool = true

@export var molestitud: float = 2.
var pos_jugador: Vector2
var pos_adelantada_jugador: Vector2
#
#func _ready() -> void:
	#%TimerMate.timeout.connect(_on_timer_mate_timeout)
	#navigation_agent.velocity_computed.connect(_on_velocity_computed)
	#navigation_agent.navigation_finished.connect(_on_navigation_finished)
#
#
#func _physics_process(_delta):
	## Do not query when the map has never synchronized and is empty.
	#if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		#return
	#if navigation_agent.is_navigation_finished():
		#return
	#
	#var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	#var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	#if navigation_agent.avoidance_enabled:
		#navigation_agent.set_velocity(new_velocity)
	#else:
		#_on_velocity_computed(new_velocity)
	##hasta aca es todo navigation, no tocar :)
#
#
#func _process(_delta: float) -> void:
	##Mientras el jugador este dentro de su navmesh, va actualizando a donde ir
	#pos_jugador = Global.get_player().global_position
	#if seguir_jugador && !mate_lleno:
		#pos_adelantada_jugador = pos_jugador + Global.get_player().velocity * 0.5
	#else:
		#pos_adelantada_jugador = pos_jugador + Global.get_player().velocity * molestitud
	#if seguir_jugador && jugador_en_navmesh:
		##Vas hacia el punto mas lejano, tratando de entorpecer al jugador
		#if global_position.distance_to(pos_jugador) < global_position.distance_to(pos_adelantada_jugador):
			#set_movement_target(pos_adelantada_jugador)
		#else:
			#set_movement_target(pos_jugador)
	#
	##calcular si el jugador volvio a entrar estar en el navmesh para seguirlo
	#Global.request_navmap_rid.emit(self, BaseCryptid.CryptidType.CARPINCHO)
	#var punto_mas_cercano: Vector2 = NavigationServer2D.map_get_closest_point(NavigationServer2D.get_maps()[0], pos_jugador)
	##var punto_mas_cercano: Vector2 = NavigationServer2D.map_get_closest_point(navigation_map_rid, posicion_jugador)
	#if !jugador_en_navmesh && punto_mas_cercano.distance_to(pos_jugador) < 5:
		#jugador_en_navmesh = true
		#print("Carpincho te va a buscar")
#
#
#func _on_navigation_finished() -> void:
	#linear_velocity = Vector2.ZERO
	##Si se choca con el player
	#if global_position.distance_to(Global.get_player().global_position) <= navigation_agent.target_desired_distance + 20:
		#if tiene_mate && !mate_lleno:
			#Global.get_player().recibir_mate()
			#tiene_mate = false
			#print("carpincho entrega mate vacio")
		#elif !tiene_mate:
			#tiene_mate = Global.get_player().piden_mate()
			#if tiene_mate:
				#mate_lleno = true
				#seguir_jugador = false
				#$TimerMate.start()
				#print("carpincho ta tomando mate :3")
	#
	#else:
		#jugador_en_navmesh = false
		#print("Carpincho se dio contra la puerta")
#
#
#func _on_timer_mate_timeout() -> void:
	#seguir_jugador = true
	#mate_lleno = false
	#print("Carpincho quiere mate!")
#
#
#func set_movement_target(movement_target: Vector2):
	#navigation_agent.set_target_position(movement_target)
#
##esto tambien no tocar
#func _on_velocity_computed(safe_velocity: Vector2):
	#linear_velocity = safe_velocity
