extends Node2D

var speed: int

func _physics_process(delta: float) -> void:
	if not Global.paused:
		position.x -= speed * delta

func pause():
	$AnimationPlayer.pause()

func unpause():
	$AnimationPlayer.play()
