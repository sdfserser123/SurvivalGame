extends CanvasModulate

@export var gradient:GradientTexture1D
@onready var point_light_2d_2: PointLight2D = $"../Objects/Player/PointLight2D2"

var time:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta * 0.3
	var value = (sin(time - PI/2) + 1.0)/2.0
	self.color = gradient.gradient.sample(value)
	point_light_2d_2.energy = 1 - value
