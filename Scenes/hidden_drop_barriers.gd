extends TileMapLayer

@onready var hidden_drop_barriers: TileMapLayer = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hidden_drop_barriers.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
