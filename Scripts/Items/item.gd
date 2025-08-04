extends Control


@onready var item_texture: TextureRect = $CenterContainer/ItemTexture
@onready var item_quantity: Label = $ItemQuantity

# Called when the node enters the scene tree for the first time.
@export var idName = ""
var itemName = ""
var itemType = ""
var itemCategory = ""
var item_amount

const TOOLS_PATH = "res://Texture/Icons/Tools/"
const FOOD_PATH = "res://Texture/Icons/Food/"
const MATERIAL_PATH = "res://Texture/Icons/Materials/"
const PLACEABLE_PATH =  "res://Texture/Environment/Structures/"

var item_data = {} 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand_val = randi() % 5
	match rand_val:
		0:
			idName = "wood_log"
		1:
			idName = "cooked_beef"
		2:
			idName = "wooden_pickaxe"
		3:
			idName = "wooden_sword"
		4:
			idName = "wooden_axe"
	load_item(idName)
	var stackSize = int(item_data.stack_size)
	item_amount = randi() % stackSize + 1
	if stackSize == 1:
		item_quantity.visible = false
	else:
		item_quantity.text = str(item_amount)
	

func load_item(id: String):
	if not ItemDb.ITEMS.has(id):
		push_error("Item ID '%s' không tồn tại trong database" % id)
		return
	
	item_data = ItemDb.ITEMS[id]

	var icon_name = item_data.get("icon_name", "")
	if icon_name == "":
		push_error("Item '%s' không có 'icon_name'" % id)
		return
	
	var texture_path = ""
	if item_data.type == "material":
		texture_path = MATERIAL_PATH
	elif item_data.type == "food":
		texture_path = FOOD_PATH
	elif item_data.type == "tools":
		texture_path = TOOLS_PATH
	elif item_data.type == "placeable":
		var dir_name = item_data.get("display_name", "")
		if item_data.catagory == "station":
			texture_path = PLACEABLE_PATH + "Stations/" + dir_name + "/"
		else:
			texture_path = PLACEABLE_PATH + "Buildings/" + dir_name + "/"
	item_texture.texture = load(texture_path + icon_name + ".png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item_quantity(amount_to_add):
	item_amount += amount_to_add
	item_quantity.text = str(item_amount)
	item_quantity.visible = item_amount > 1

func decrease_item_quantity(amount_to_decrease):
	item_amount -= amount_to_decrease
	item_quantity.text = str(item_amount)
	item_quantity.visible = item_amount > 1

func set_item(iN, iA):
	idName = iN
	item_amount = iA
	
	load_item(idName)
	var stackSize = int(item_data.stack_size)
	if stackSize == 1:
		item_quantity.visible = false
	else:
		item_quantity.visible = true
		item_quantity.text = str(item_amount)
