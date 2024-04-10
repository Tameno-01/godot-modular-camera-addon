extends Area3D


@export var camera: ModularCamera
@export var player: CollisionObject3D
@export var behaviour_node: CameraBehaviourNode


func _on_body_entered(body):
	if body == player:
		camera.add_behaviour(behaviour_node.behaviour)


func _on_body_exited(body):
	if body == player:
		camera.remove_behaviour(behaviour_node.behaviour)
