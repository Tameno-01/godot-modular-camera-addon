extends Area3D


@export var player: CollisionObject3D
@export var behaviour_node: CameraBehaviourNode


func _on_body_entered(body):
	if body == player:
		behaviour_node.add_behaviour()


func _on_body_exited(body):
	if body == player:
		behaviour_node.remove_behaviour()
