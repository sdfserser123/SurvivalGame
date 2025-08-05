extends StaticBody2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var workbench_collision: CollisionShape2D = $WorkbenchCollision
@onready var collision_shape_2d: CollisionShape2D = $hurt_box/CollisionShape2D
@onready var loot_base = get_tree().get_first_node_in_group("Drops")
@onready var hit_flash: AnimationPlayer = $hit_flash
@onready var crafting_area_collision: CollisionShape2D = $CraftingArea/CraftingAreaCollision

var hp = 5
var is_placed = true

var drop = preload("res://Scenes/Drops/drop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_placed:
		crafting_area_collision.disabled = true

func _physics_process(delta: float) -> void:
	if hp <= 0:
		death()

func death():
	workbench_collision.disabled = true
	collision_shape_2d.disabled = true

	var drop_count = 1
	for i in range(drop_count):
		var new_drop = drop.instantiate()
		
		# Tính vị trí ngẫu nhiên trong hình tròn bán kính 20
		var angle = randf_range(0, TAU)  # TAU = 2*PI
		var radius = randf_range(0, 20)
		var offset = Vector2(cos(angle), sin(angle)) * radius
		
		new_drop.global_position = global_position + offset
		new_drop.idName = "wooden_workbench"
		
		loot_base.call_deferred("add_child", new_drop)

	self.visible = false
	queue_free()


func _on_hurt_box_area_entered(area: Area2D) -> void:
		if area.is_in_group("Attack"):
			var weapon_id = ""
			var damage = 0
			if area.has_method("get_weapon_id") and area.has_method("get_weapon_damage"):
				weapon_id = area.get_weapon_id()
				damage = area.get_weapon_damage()
				print(damage)

			# Kiểm tra có phải rìu không
			if ItemDb.ITEMS.has(weapon_id):
				var item_data = ItemDb.ITEMS[weapon_id]
				if item_data.get("catagory", "") == "axe":
					hp -= damage
					hit_flash.play("hit_flash")
					if hp <= 0:
						death()


func _on_crafting_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.standing_near.append("wooden_workbench")


func _on_crafting_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.standing_near.erase("wooden_workbench")
