extends CharacterBody2D

var active := true
@export var startLives := 3
@export var speed := 600
@export var scrollSpeed := 1350
var rotationAngle = Vector2(scrollSpeed, speed).angle()

func _ready() -> void:
	Global.lives = startLives
	Global.scrollSpeed = scrollSpeed

func _physics_process(delta: float) -> void:
	if not Global.paused:
		var targetRotation = 0
		var targetY := position.y
		
		if Input.is_action_pressed("down"):
			targetY += speed * delta
			targetRotation = rotationAngle
		elif Input.is_action_pressed("up"):
			targetY -= speed * delta
			targetRotation = -rotationAngle
		
		if not (targetY <= 20 or targetY >= get_viewport_rect().size.y-20):
			position.y = targetY
		else:
			targetRotation = 0
		
		rotate_player(targetRotation)
	if Input.is_action_just_pressed("pause"):
		Global.paused = not Global.paused

func hit(damage):
	active = false
	Global.lives -= damage
	
	if Global.lives <= 0:
		print("dead")
		#Global.paused = true
		#await get_tree().create_timer(2).timeout
		get_tree().reload_current_scene()
	
	$Timers/Hit.start()
	$AnimationPlayer.play("Flashing")

func _on_hit_timeout() -> void:
	active = true
	$AnimationPlayer.stop()

func rotate_player(target):
	var tween := create_tween()
	tween.tween_property(self, "rotation", target, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
