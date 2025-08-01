extends StaticBody2D

@onready var hit_flash: AnimationPlayer = $hit_flash
@onready var tree_animation: AnimationPlayer = $TreeAnimation
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var collision: CollisionShape2D = $Collision
@onready var collision_shape_2d: CollisionShape2D = $hurtBox/CollisionShape2D
@onready var loot_base = get_tree().get_first_node_in_group("Drops")

var tree_drop = preload("res://Scenes/Drops/drop.tscn")

var playerpos = Vector2.ZERO

var hp = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(tree_drop)
	print("Loot base:", loot_base)  # Nếu null -> group "Drops" chưa được gán đúng
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp <= 0:
		death()

func _on_hurt_box_body_entered(body: Node2D) -> void:
	playerpos = player.global_position
	if body.is_in_group("Attack"):
		hp -= 1
		hit_flash.play("hit_flash")
		

func death():
	if playerpos.x > self.global_position.x:
		tree_animation.play("get_hit")
	else:
		tree_animation.play("hit_get")


func _on_tree_animation_animation_finished(anim_name: StringName) -> void:
	collision.disabled = true
	collision_shape_2d.disabled = true

	var drop_count = randi_range(2, 4)
	for i in range(drop_count):
		var new_drop = tree_drop.instantiate()
		
		# Tính vị trí ngẫu nhiên trong hình tròn bán kính 20
		var angle = randf_range(0, TAU)  # TAU = 2*PI
		var radius = randf_range(0, 20)
		var offset = Vector2(cos(angle), sin(angle)) * radius
		
		new_drop.global_position = global_position + offset
		new_drop.idName = "wood_log"
		
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
			print(weapon_id)

		# Kiểm tra có phải rìu không
		if ItemDb.ITEMS.has(weapon_id):
			print("it has")
			var item_data = ItemDb.ITEMS[weapon_id]
			if item_data.get("catagory", "") == "axe":
				hp -= damage
				hit_flash.play("hit_flash")
				if hp <= 0:
					death()
