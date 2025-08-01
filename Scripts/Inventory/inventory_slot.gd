extends Panel


var ItemClass = preload("res://Scenes/UI/Items/item.tscn")
var item = null
var slot_index
var selected_texture
var slot_type

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_texture = null
	
func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	call_deferred("update_item_position", item)
	item = null

func putInSlot(new_item):
	item = new_item
	item.position = Vector2.ZERO
	var inventoryNode = find_parent("Inventory")
	if item.get_parent() == inventoryNode:
		inventoryNode.remove_child(item)
	add_child(item)
	item.mouse_filter = Control.MOUSE_FILTER_STOP

func update_item_position(item):
	item.global_position = get_global_mouse_position()

func initialize_item(idName, item_amount):
	print(idName)
	print(item_amount)
	if item == null:
		item = ItemClass.instantiate()
		add_child(item)
		item.set_item(idName, item_amount)
	else:
		item.set_item(idName, item_amount)

func refresh_style():
	if SlotType.HOTBAR == slot_type and PlayerInventory.active_item_slot == slot_index:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
