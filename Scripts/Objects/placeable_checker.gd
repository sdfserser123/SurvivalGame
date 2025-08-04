extends Area2D

@onready var parent = self.get_parent()
@onready var sprite = parent.get_node("WorkbenchTexture")

var available = true
var original_color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_color = sprite.modulate


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Buildings"):
		sprite.modulate = Color(0.8, 0, 0, 0.5)
		available = false
	else:
		sprite.modulate = original_color
		available = true


func _on_body_exited(body: Node2D) -> void:
	sprite.modulate = original_color
	available = true
