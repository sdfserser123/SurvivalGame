extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

var can_place = false
var item_to_place = null
var preview_instance = null
const MODEL_PATH = "res://Scenes/Objects/"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_current_item():
	item_to_place = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
	_create_placement_preview()

func _create_placement_preview():
	if item_to_place == null:
		return
	var item_data = ItemDb.ITEMS[item_to_place]

	var icon_name = item_data.get("icon_name", "")
	if icon_name == "":
		push_error("Item '%s' không có 'icon_name'" % item_to_place)
		return
	var path = MODEL_PATH + icon_name + ".tscn"
	var preview_scene = load(path)
	if preview_scene == null:
		push_error("Không tìm thấy scene: " + path)
		return
	
	preview_instance = preview_scene.instantiate()
	preview_instance.modulate = Color(1, 1, 1, 0.5) # làm mờ preview
	for child in preview_instance.get_children():
		if child is CollisionShape2D:
			child.disabled = true
	# Thêm preview vào node chứa object trong world
	var objects_node = get_tree().current_scene.get_node("Objects")
	objects_node.add_child(preview_instance)

func _physics_process(delta: float) -> void:
	if preview_instance != null:
		var mouse_position = get_global_mouse_position()
		var rounded_position = Vector2(int(round(mouse_position.x)), int(round(mouse_position.y)))
		preview_instance.global_position = rounded_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		print("placing")
		place_item()

func place_item():
	if preview_instance == null:
		print("null")
		return
	var placeable_node = preview_instance.get_node("Placeable")
	can_place = placeable_node.available
	if !can_place:
		return
	
	# Tạo instance mới để đặt cố định vào thế giới
	var item_data = ItemDb.ITEMS[item_to_place]
	var icon_name = item_data.get("icon_name", "")
	var path = MODEL_PATH + icon_name + ".tscn"
	var scene = load(path)
	var placed_instance = scene.instantiate()
	placed_instance.global_position = preview_instance.global_position
	
	# Thêm vào node quản lý object trong thế giới
	var objects_node = get_tree().current_scene.get_node("Objects")
	objects_node.add_child(placed_instance)
	var placeable_instance = placed_instance.get_node("Placeable")
	placeable_instance.queue_free()
	# Xóa item khỏi hotbar
	player.remove_selected_item(item_to_place, 1)
	
	placeable_node.queue_free()
	# Xóa preview
	preview_instance.queue_free()
	can_place = false
	preview_instance = null
	item_to_place = null
	
func clear_instance():
	if preview_instance == null:
		return
	preview_instance.queue_free()

func _process(delta: float) -> void:
	pass
