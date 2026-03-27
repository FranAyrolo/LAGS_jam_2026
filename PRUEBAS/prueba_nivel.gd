extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	#%Camera2D.reparent(%Player)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	#$Carpincho.set_movement_target(%Player.global_position)
	#print("timer timeout!!")
	pass
