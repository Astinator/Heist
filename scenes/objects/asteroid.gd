extends Node2D

@onready var selectedType := $Type.get_child(Global.totalWeights.pop_at(randi_range(0, len(Global.totalWeights))))

var speed := randf_range(1200,1800)
var rotationSpeed := randf_range(-1, 1)
var newScale := randf_range(0.7,1.5)

var defaultWeight := 10
var weightOverrides := {
	"RoundBlue": 1,
	"Torus": 2,
	"Cube": 1,
	"Spatula": 4,
}

signal explode(pos, speed, scale)

func _ready() -> void:
	for type in $Type.get_children():
		type.get_child(0).disabled = true
	
	selectedType.visible = true
	selectedType.scale = Vector2(newScale,newScale)
	selectedType.connect("body_entered", collision)
	
	selectedType.get_child(0).disabled = false
	selectedType.get_child(0).scale = Vector2(newScale,newScale)
	

func _physics_process(delta: float) -> void:
	if not Global.paused:
		position.x -= speed * delta
		rotation += rotationSpeed * delta
		if position.x < -100:
			queue_free()

func get_texture_width():
	return selectedType.get_child(1).texture.get_width()

func collision(body):
	if "active" in body and body.active:
		explode.emit(global_position, speed, newScale)
		if "hit" in body:
			body.hit(1)
		queue_free()
