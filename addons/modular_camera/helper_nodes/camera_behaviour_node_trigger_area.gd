## A helper node that adds a behaviour to the camera once a player enters it.
@tool
class_name CameraBehaviourNodeTriggerAera
extends Area3D

## When this node enters this area, the behaviour will be added.
@export var player: CollisionObject3D
## The behaviour node this area is linked to.
@export var camera_behaviour_node: CameraBehaviourNode


func _ready():
	connect(&"body_entered", _on_anything_entered)
	connect(&"area_entered", _on_anything_entered)
	connect(&"body_exited", _on_anything_exited)
	connect(&"area_exited", _on_anything_exited)


func _on_anything_entered(collision_object: CollisionObject3D):
	if collision_object == player:
		if camera_behaviour_node:
			camera_behaviour_node.add_behaviour()


func _on_anything_exited(collision_object: CollisionObject3D):
	if collision_object == player:
		if camera_behaviour_node:
			camera_behaviour_node.remove_behaviour()
