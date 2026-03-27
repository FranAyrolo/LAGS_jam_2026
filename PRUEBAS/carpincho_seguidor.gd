extends RigidBody2D

@export var movement_speed: float = 500.
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var navigation_map_rid: RID

var seguir_jugador: bool = false
var esperando_jugador_salga: bool = false

func _ready() -> void:
	%TimerMate.timeout.connect(_on_timer_mate_timeout)
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	navigation_agent.navigation_finished.connect(_on_navigation_finished)


func _physics_process(_delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func _process(_delta: float) -> void:
	if seguir_jugador && !esperando_jugador_salga:
		set_movement_target(Global.get_player_global_position())
	
	#calcular si el jugador vuelve a estar en el navmesh para seguirlo
	Global.request_navmap_rid.emit(self, Global.CryptidType.CARPINCHO)
	var posicion_jugador: Vector2 = Global.get_player_global_position()
	var punto_mas_cercano: Vector2 = NavigationServer2D.map_get_closest_point(NavigationServer2D.get_maps()[0], posicion_jugador)
	#var punto_mas_cercano: Vector2 = NavigationServer2D.map_get_closest_point(navigation_map_rid, posicion_jugador)
	if esperando_jugador_salga && punto_mas_cercano.distance_to(posicion_jugador) < 5:
		esperando_jugador_salga = false
		print("Carpincho te va a buscar")


func _on_navigation_finished() -> void:
	linear_velocity = Vector2.ZERO
	
	if global_position.distance_to(Global.get_player_global_position()) <= navigation_agent.target_desired_distance + 20:
		seguir_jugador = false
		$TimerMate.start()
		print("carpincho ta tomando mate :3")
	else:
		esperando_jugador_salga = true
		print("Carpincho se dio contra la puerta")


func _on_timer_mate_timeout() -> void:
	seguir_jugador = true
	print("Carpincho quiere mate!")


func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)


func _on_velocity_computed(safe_velocity: Vector2):
	linear_velocity = safe_velocity
