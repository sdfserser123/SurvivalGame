extends Area2D

@onready var drop_texture: Sprite2D = $DropTexture
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var idName = ""
var dropName = ""
var dropType = ""
var dropCategory = ""

const TOOLS_PATH = "res://Texture/Icons/Tools/"
const FOOD_PATH = "res://Texture/Icons/Food/"
const MATERIAL_PATH = "res://Texture/Icons/Materials/"

var target = null
var speed = 0

var item_data = {} 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_item(idName)

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
	print(texture_path + icon_name + ".png")
	drop_texture.texture = load(texture_path + icon_name + ".png")
	
func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collect():
	collision_shape_2d.call_deferred("set","disabled",true)
	drop_texture.visible = false
	PlayerInventory.add_item(idName, 1)
	queue_free()

func set_target(player, delta):
	target = player
	speed += 5*delta
