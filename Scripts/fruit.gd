class_name Fruit extends RigidBody2D
@export var fruit_type = GameManager.FruitType.UNKNOWN
@export var held = false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var collision_detected = false
const MOVE_SPEED = 20

func _ready() -> void:
	if held:
		SignalBus.drop_fruit.connect(_unfreeze_fruit, CONNECT_ONE_SHOT)
		set_freeze_enabled(true)
		set_freeze_mode(1)
		print("I am held")
	if fruit_type == GameManager.FruitType.UNKNOWN:
		print("Type not set correctly")
		return
	print(GameManager.fruit_names[fruit_type] + " " + str(get_instance_id()) + " has spawned")


func _physics_process(delta: float) -> void:
	if GameManager.game_loaded and held:
		var mouse_pos = get_global_mouse_position()
		var vect = (mouse_pos - global_position) * Vector2(1, 0)
		var xvelocity = vect * delta * MOVE_SPEED
		xvelocity.x = clamp(xvelocity.x, -60, 60)
		move_and_collide(xvelocity)
		
	
func _unfreeze_fruit() -> void:
	if held:
		set_collision_mask_value(2, false)
		held = false
		linear_velocity *= 0
		set_freeze_enabled(false)

func _collision_cleanup(id) -> void:
	if get_instance_id() == id:
		print(str(get_instance_id()) + " exited")
		collision_detected = true
		collision_shape_2d.set_deferred("set_disabled", true)
		queue_free()
	
func _on_body_entered(body: Node) -> void:
	var group_name = GameManager.fruit_names[fruit_type].capitalize()
	if not is_in_group(group_name):
		print("I am not in group " + group_name)
		return
	
	if collision_detected:
		print("Collision Detected")
		return
		
	if held and body.is_in_group("Fruit"):
		SignalBus.game_lost.emit()
	
	if is_in_group("Megamelon"):
		print("I am the Melon")
		return
		
	if body.is_in_group(group_name):
		print("I am " + GameManager.fruit_names[fruit_type] + " " + str(get_instance_id()))
		print("Collision detected between " + str(get_instance_id()) + " and " + str(body.get_instance_id()))
		if get_instance_id() > body.get_instance_id():
			return
		
		collision_detected = true
		body._collision_cleanup(body.get_instance_id())
		get_node("CollisionShape2D").set_deferred("set_disabled", true)
		var midpoint = (global_position + body.global_position) / 2
		print("Emit from " + str(get_instance_id()))
		SignalBus.fruit_combo.emit(fruit_type, midpoint)
		print(str(get_instance_id()) + " exited")
		queue_free()
		
