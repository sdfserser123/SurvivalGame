extends CenterContainer

var ItemClass = preload("res://Scenes/UI/Items/item.tscn")
var item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi() % 2 == 0:
		item = ItemClass.instantiate()
		add_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
