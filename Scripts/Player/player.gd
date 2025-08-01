extends CharacterBody2D

@onready var player_texture: Sprite2D = $PlayerTexture
@onready var player_animation: AnimationPlayer = $PlayerAnimation

var is_movable = true
var got_hit = false
var movement_speed = 100
var last_movement = Vector2.UP
var can_attack = true
var direction = Vector2.DOWN

@onready var hitbox: Area2D = $hitbox
@onready var attack_collision: CollisionShape2D = $hitbox/AttackCollision
@onready var attack_cd: Timer = $hitbox/CollisionShape2D/AttackCD

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and can_attack:
		can_attack = false
		if direction == Vector2.RIGHT:
			player_animation.play("chopping_side")
		elif direction == Vector2.LEFT:
			player_animation.play("chopping_side")
		elif direction == Vector2.DOWN:
			player_animation.play("chopping_down")
		elif direction == Vector2.UP:
			player_animation.play("chopping_up")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if !is_movable:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	movement()

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

func _on_attack_cd_timeout() -> void:
	attack_collision.disabled = true


func _on_player_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "chopping_down" || anim_name == "chopping_side" || anim_name == "chopping_up":
		can_attack = true


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Drops"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Drops"):
		area.collect()
