extends Node2D

var asteroidScene := preload("res://scenes/objects/asteroid.tscn")
var explosionScene := preload("res://scenes/projectiles/explosion.tscn")

func _ready() -> void:
	$Background.scale = Vector2(get_viewport_rect().size.x/$Background.texture.get_width(), get_viewport_rect().size.y/$Background.texture.get_height())
	Global.paused = false
	$Timer.wait_time = 0.7
	calc_probabilities()
	unpause()

func _process(delta: float) -> void:
	if not Global.paused:
		$Background.position.x -= Global.scrollSpeed * delta
		if $Background.position.x <= 0:
			$Background.position.x = get_viewport_rect().size.x

func _physics_process(delta: float) -> void:
	if not Global.paused:
		Global.distance += Global.scrollSpeed * delta # meters

func _on_timer_timeout() -> void:
	var asteroid := asteroidScene.instantiate()
	asteroid.position = Vector2(get_viewport_rect().size.x+100, randf_range(0, get_viewport_rect().size.y) if randi_range(0,4) else $Player.global_position.y)
	asteroid.connect("explode", create_explosion)
	$Asteroids.add_child(asteroid)
	
	$Timer.wait_time = max((0.999 ** (Global.distance / 1000.0)) - 0.7, 0.13)

func create_explosion(pos, speed, newScale):
	var explosion = explosionScene.instantiate()
	
	explosion.position = pos
	explosion.speed = speed
	explosion.scale = Vector2(newScale, newScale)
	
	$Explosions.add_child(explosion)

func calc_probabilities():
	var scene := asteroidScene.instantiate()
	
	for type in scene.get_child(0).get_children():
		var typeName := str(type.name)
		var weight = scene.weightOverrides[typeName] if typeName in scene.weightOverrides else scene.defaultWeight
		var index  = type.get_index()
		
		for x in range(weight):
			Global.totalWeights.append(int(index))
		
func pause():
	$Timer.paused = true

func unpause():
	$Timer.paused = false
