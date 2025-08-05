extends Control

@onready var item_container: HBoxContainer = $ScrollContainer/ItemContainer
@onready var player = get_tree().get_first_node_in_group("Player")
var old_craftable = []

var is_open = false
var just_closed = false
@onready var inventory = get_tree().get_nodes_in_group("UI") \
	.filter(func(node): return node.has_method("initialize_inventory"))[0]

const slotClass = preload("res://Scripts/Inventory/inventory_slot.gd")
var slot_instance = preload("res://Scenes/UI/Inventory/slot.tscn")

var total_item
var craftable_item
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_crafting()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory") && is_open:
		close()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_craftable_item(total_item : Dictionary):
	var result = []
	for recipe_name in RecipeDb.RECIPE.keys():
		var recipe = RecipeDb.RECIPE[recipe_name]
		var can_craft = true
		var able_to_craft = false
		var near_stations = player.standing_near
		print(near_stations)
		for ingredient in recipe["ingredients"]:
			var item_id = ingredient["item"]
			var required_amount = ingredient["amount"]
			var have_amount = total_item.get(item_id,0)
			print("You have: ", have_amount)
			print("You need: ", required_amount)
			if have_amount < required_amount:
				can_craft = false
				break
		if recipe.has("station"):
			for station in near_stations:
				if station == recipe["station"]:
					able_to_craft = true
					break
		if can_craft && able_to_craft:
				result.append(recipe_name)
	return result

func initialize_crafting():
	total_item = PlayerInventory.get_total_item_counts()
	craftable_item = get_craftable_item(total_item)

	# Xóa các slot cũ trước khi thêm slot mới
	queue_free_children(item_container)
	old_craftable.clear()

	for recipe_name in craftable_item:
		var slot = slot_instance.instantiate()
		item_container.add_child(slot)
		slot.initialize_item(recipe_name, 1)
		
		# Kết nối signal gui_input
		slot.gui_input.connect(slot_gui_input.bind(slot))
	
	# Cập nhật lại danh sách đã tạo
	old_craftable = craftable_item.duplicate()
	

func slot_gui_input(event: InputEvent, slot: slotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			print("is pressed")
			if find_parent("UserInterface").holding_item != null:
				if !slot.item:
					return
				else:
					if find_parent("UserInterface").holding_item.idName != slot.item.idName:
						return
					else:
						left_click_same_item(slot)
			elif slot.item:
				try_craft(slot.item.idName)
				left_click_not_holding_item(slot)

func try_craft(recipe_name: String):
	var recipe = RecipeDb.RECIPE[recipe_name]
	
	# Kiểm tra nguyên liệu
	for ingredient in recipe["ingredients"]:
		var item_id = ingredient["item"]
		var required_amount = ingredient["amount"]
		var have_amount = PlayerInventory.get_total_item_counts().get(item_id, 0)
		if have_amount < required_amount:
			print("Không đủ nguyên liệu để chế tạo:", recipe_name)
			return
	
	# Trừ nguyên liệu
	for ingredient in recipe["ingredients"]:
		var item_id = ingredient["item"]
		var required_amount = ingredient["amount"]
		PlayerInventory.remove_item_by_id(item_id, required_amount) # bạn cần có hàm này
	# Thêm thành phẩm
	print("Đã chế tạo:", recipe_name)
	
	# Cập nhật lại danh sách craftable
	queue_free_children(item_container)
	initialize_crafting()
	inventory.initialize_inventory()

# Helper function để xóa con trong item_container
func queue_free_children(item_container):
	for child in item_container.get_children():
		child.queue_free()

func left_click_same_item(slot: slotClass):
	var slot_idName = slot.item.idName
	var stackSize = int(ItemDb.ITEMS[slot_idName].stack_size)
	var able_to_add = stackSize - slot.item.item_amount

	if able_to_add == 0:
		var temp_item = slot.item

		# Cập nhật PlayerInventory
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)

		# Swap trong scene
		slot.pickFromSlot()
		slot.putInSlot(find_parent("UserInterface").holding_item)

		find_parent("UserInterface").holding_item = temp_item
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	else:
		# Gộp stack nếu chưa full
		var to_add = min(able_to_add, find_parent("UserInterface").holding_item.item_amount)
		PlayerInventory.add_item_quantity(slot, to_add)
		slot.item.add_item_quantity(to_add)
		find_parent("UserInterface").holding_item.decrease_item_quantity(to_add)

		if find_parent("UserInterface").holding_item.item_amount <= 0:
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null

func left_click_not_holding_item(slot: slotClass):
	PlayerInventory.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()


func close():
	is_open = false
	visible = false
	get_tree().paused = false
	just_closed = true
