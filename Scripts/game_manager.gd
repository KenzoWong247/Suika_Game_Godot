extends Node
enum FruitType {CHERRY, STRAWBERRY, GRAPE, LEMON, PEAR, APPLE, ORANGE, BANANA, PINEAPPLE, MELON, MEGAMELON, UNKNOWN}
var fruit_names = ["cherry", "strawberry", "grape", "lemon", "pear", "apple", "orange", "banana", "pineapple", "melon", "megamelon"]
var game_loaded = false
var lost = false

func _ready() -> void:
	SignalBus.fruit_combo.connect(_spawn_fruit_at, CONNECT_DEFERRED)
	SignalBus.game_loaded.connect(_game_load, CONNECT_ONE_SHOT)
	SignalBus.game_lost.connect(_game_lost)
	get_new_fruit()
	
func get_new_fruit():
	var fruit = _spawn_fruit_at(randi_range(0, 5), Vector2(368, 80), true)
	
func _game_load():
	game_loaded = true
	
func _game_lost():
	print("Game Lost")
	lost = true
	var fruit_scenes = get_node("/root/Game/Fruits").get_children()
	for fruit in fruit_scenes:
		fruit.apply_impulse(Vector2(0, -3000))
	
func _spawn_fruit_at(fruit_type, position, held=false):
	var next_fruit = fruit_type + 1
	if next_fruit < len(fruit_names):
		print(fruit_names[next_fruit])
		var fruit_scene = load("res://Scenes/" + fruit_names[next_fruit] + ".tscn").instantiate()
		print("Game manager spawned " + fruit_names[next_fruit] + " " + str(fruit_scene.get_instance_id()))
		fruit_scene.position = position
		fruit_scene.held = held
		if held:
			fruit_scene.set_collision_mask_value(2, true)
		get_node("/root/Game/Fruits").add_child(fruit_scene)
		
	return
