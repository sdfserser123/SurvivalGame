extends Node

signal active_item_updated(slot_index)
signal remove_the_item(slot_index)
signal inventory_updated

const slotClass = preload("res://Scripts/Inventory/inventory_slot.gd")
const ItemClass = preload("res://Scripts/Items/item.gd")

@onready var player = get_tree().get_first_node_in_group("Player")

const NUM_INVENTORY_SLOTS = 30
const NUM_HOTBAR_SLOTS = 10

var inventory = {
	0: ["wooden_axe", 1],
	15: ["wood_log", 15],
	16: ["wood_log", 12],
	20: ["stone", 14]
}

var hotbar = {
	
	1: ["wooden_axe", 1],
	5: ["wooden_workbench", 1]
}

var active_item_slot = 0

func add_item(idName, item_amount):
	for item in inventory:
		if inventory[item][0] == idName:
			var stackSize = int(ItemDb.ITEMS[idName].stack_size)
			var able_to_add = stackSize - inventory[item][1]
			if able_to_add >= item_amount:
				inventory[item][1] += item_amount
				return
			else:
				inventory[item][1] += able_to_add
				item_amount = item_amount - able_to_add
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [idName, item_amount]
			return

func remove_item(slot: slotClass):
	if slot.slot_type == slotClass.SlotType.HOTBAR:
		hotbar.erase(slot.slot_index)
	else:
		inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: slotClass):
	if slot.slot_type == slotClass.SlotType.HOTBAR:
		hotbar[slot.slot_index] = [item.idName, item.item_amount]
	else:
		inventory[slot.slot_index] = [item.idName, item.item_amount]
	
func add_item_quantity(slot: slotClass, quantity_to_add: int):
	if slot.slot_type == slotClass.SlotType.HOTBAR:
		hotbar[slot.slot_index][1] += quantity_to_add
	else:
		inventory[slot.slot_index][1] += quantity_to_add

func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	player.update_current_item()
	emit_signal("active_item_updated", active_item_slot) # ✅ FIXED

func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	player.update_current_item()
	emit_signal("active_item_updated", active_item_slot) # ✅ FIXED

func set_active_slot(index: int):
	if index != active_item_slot:
		active_item_slot = index
		player.update_current_item()
		emit_signal("active_item_updated", active_item_slot)

func decrease_item(num: int):
	var slot_index = active_item_slot
	if not hotbar.has(slot_index):
		return # Slot trống, không làm gì

	# Giảm số lượng
	hotbar[slot_index][1] -= num

	# Nếu <= 0 thì xóa slot
	if hotbar[slot_index][1] <= 0:
		emit_signal("remove_the_item", active_item_slot)
		hotbar.erase(slot_index)

func get_total_item_counts():
	var counts := {}
	for slot in inventory.values():
		var item_id = slot[0]
		var amount = slot[1]
		if item_id == null:
			continue
		if item_id in counts:
			counts[item_id] += amount
		else:
			counts[item_id] = amount
	print(counts)
	return counts  
	
func remove_item_by_id(item_id: String, amount: int):
	# Duyệt qua inventory
	var slots_to_remove := []
	for slot_index in inventory.keys():
		if inventory[slot_index][0] == item_id:
			var current_amount = inventory[slot_index][1]
			if current_amount > amount:
				inventory[slot_index][1] -= amount
				return
			else:
				amount -= current_amount
				slots_to_remove.append(slot_index)
				if amount <= 0:
					emit_signal("remove_the_item", slot_index)
					break
	
	# Xóa slot nào đã hết
	for slot_index in slots_to_remove:
		inventory.erase(slot_index)
	print("xong")
	emit_signal("inventory_updated")
