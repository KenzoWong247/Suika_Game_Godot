extends Node2D

@onready var timer: Timer = $Timer
const MOVE_SPEED = 200
var lost = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.game_loaded.emit()
	SignalBus.game_lost.connect(_on_loss)
	var screen_size = get_viewport().get_visible_rect().size


func _process(delta: float) -> void:
	if not lost:
		if Input.is_action_just_pressed("drop") and timer.is_stopped():
			SignalBus.drop_fruit.emit()
			timer.start()
		
		

func _on_loss():
	lost = true
	
func _on_timer_timeout() -> void:
	GameManager.get_new_fruit()
