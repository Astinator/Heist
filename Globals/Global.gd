extends Node

signal updateUI

var lives : int:
	set(value):
		if value >= 0: # If value-1 != 0, doesnt allow lives to go negative
			lives = value
			updateUI.emit()

var distance := 0.0:
	set(value):
		distance = value
		updateUI.emit()

var scrollSpeed: int

var paused := false:
	set(value):
		var pauseable := get_tree().get_nodes_in_group("Pauseable")
		for node in pauseable:
			if value:
				node.pause()
			else:
				node.unpause()
		paused = value

var totalWeights: Array
