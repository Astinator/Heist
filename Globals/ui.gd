extends CanvasLayer

func _ready() -> void:
	Global.connect("updateUI", update)

func update():
	$Labels/Distance.text = str(int(Global.distance / 1000.0)) + "km"
	$Labels/Lives.text = str(Global.lives)
