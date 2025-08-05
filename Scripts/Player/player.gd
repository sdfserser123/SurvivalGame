extends CharacterBody2D

@onready var player_texture: Sprite2D = $PlayerTexture
@onready var player_animation: AnimationPlayer = $PlayerAnimation
@onready var item_placer: Node2D = $ItemPlacer

var is_movable = true
var got_hit = false
var movement_speed = 100
var last_movement = Vector2.UP
var can_attack = true
var direction = Vector2.DOWN
var current_item_id: String = ""
var current_attack_damage = 0
var standing_near = [""]

@onready var hitbox: Area2D = $hitbox
@onready var attack_collision: CollisionShape2D = $hitbox/AttackCollision
@onready var attack_cd: Timer = $hitbox/CollisionShape2D/AttackCD

func _input(event: InputEvent) -> void:
	pass

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if !is_movable:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Gọi attack nếu đang giữ phím và có thể tấn công
	if Input.is_action_pressed("attack") and can_attack:
		do_attack()

	movement()

func _process(delta: float) -> void:
	pass
	

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if can_attack:
		if mov.x > 0:
			player_texture.flip_h = false
		elif mov.x < 0:
			player_texture.flip_h = true
		if mov != Vector2.ZERO:
			last_movement = mov
		velocity = mov.normalized()*movement_speed
		if got_hit:
			pass
		elif velocity.x != 0 or velocity.y != 0:
			if velocity.x > 0:
				player_animation.play("run_side")
				player_texture.flip_h = false
				direction = Vector2.RIGHT
			elif velocity.x < 0:
				player_animation.play("run_side")
				player_texture.flip_h = true
				direction = Vector2.LEFT
			elif velocity.y > 0:
				player_animation.play("run_down")
				direction = Vector2.DOWN
			elif velocity.y < 0:
				player_animation.play("run_up")
				direction = Vector2.UP
		else:
			if mov == Vector2.ZERO && can_attack:
				if direction == Vector2.RIGHT:
					player_animation.play("idle_side")
					player_texture.flip_h = false
				elif direction == Vector2.LEFT:
					player_animation.play("idle_side")
					player_texture.flip_h = true
				elif direction == Vector2.DOWN:
					player_animation.play("idle_down")
				elif direction == Vector2.UP:
					player_animation.play("idle_up")
	else:
		velocity = Vector2.ZERO
	update_hitbox_direction()
	move_and_slide()

func update_hitbox_direction():
	var offset = Vector2.ZERO
	if direction == Vector2.RIGHT:
		offset = Vector2(23, 5)  # bên phải
	elif direction == Vector2.LEFT:
		offset = Vector2(-23, 5) # bên trái
	elif direction == Vector2.DOWN:
		offset = Vector2(0, 21)  # xuống
	elif direction == Vector2.UP:
		offset = Vector2(0, -18) # lên
	hitbox.position = offset

func do_attack():
	if _on_item_bar_item_selected() == "axe":
		var item_id = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		print(item_id)
		var item_info = ItemDb.ITEMS.get(item_id, {})
		print(item_info)
		can_attack = false
		
		if direction == Vector2.RIGHT:
			player_animation.play("chopping_side")
		elif direction == Vector2.LEFT:
			player_animation.play("chopping_side")
		elif direction == Vector2.DOWN:
			player_animation.play("chopping_down")
		elif direction == Vector2.UP:
			player_animation.play("chopping_up")
	else:
		return

func _check_current_item():
	if _on_item_bar_item_selected() == "placeable":
		item_placer.get_current_item()
	else:
		item_placer.clear_instance()

func _on_item_bar_item_selected():
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		var item_data = PlayerInventory.hotbar[PlayerInventory.active_item_slot]
		var id_name = item_data[0]
		if ItemDb.ITEMS.has(id_name) and ItemDb.ITEMS[id_name].type == "tools":
			if ItemDb.ITEMS[id_name].catagory == "axe":
				return "axe"
		elif ItemDb.ITEMS.has(id_name) and ItemDb.ITEMS[id_name].type == "placeable":
			return "placeable"

func update_current_item():
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		var item_data = PlayerInventory.hotbar[PlayerInventory.active_item_slot]
		current_item_id = item_data[0]
		var item_info = ItemDb.ITEMS.get(current_item_id, {})
		current_attack_damage = item_info.get("item_attack", 1)
	else:
		current_item_id = ""
		current_attack_damage = 0

func remove_selected_item(item, num):
	if !PlayerInventory.hotbar.has(PlayerInventory.active_item_slot):
		return
	var item_data = PlayerInventory.hotbar[PlayerInventory.active_item_slot]
	if item_data == null:
		return
	if item_data.size() == 0:
		return
	
	var current_item_id = item_data[0]
	if current_item_id == item:
		PlayerInventory.decrease_item(num)

func get_what_are_near():
	return standing_near

func _on_attack_cd_timeout() -> void:
	attack_collision.disabled = true


func _on_player_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("chopping"):
		can_attack = true


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Drops"):
		area.target = self

func _handle_item_selection(item):
	pass

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Drops"):
		area.collect()
