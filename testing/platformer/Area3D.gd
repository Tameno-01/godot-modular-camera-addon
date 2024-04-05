extends Area3D


@export var camera: ModularCamera
@export var player: CollisionObject3D
@export var behaviour: CameraBehaviour


func _ready():
	behaviour.target_override = global_position


func _on_body_entered(body):
	if body == player:
		camera.add_behaviour(behaviour)


func _on_body_exited(body):
	if body == player:
		camera.remove_behaviour(behaviour)
