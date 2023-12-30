@tool
class_name TESTCameraBehaviourSpin
extends CameraBehaviour


func _on_start():
	properties.direction = 0.0


func _process(delta: float):
	properties.direction += delta
