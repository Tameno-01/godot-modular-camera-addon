## A helper node that adds a behaviour to the camera once the player enters it.
@tool
class_name CameraBehaviourNodeTriggerAera
extends Area3D

## When this node enters this area, the behaviour will be added.
@export var player: CollisionObject3D
## The behaviour node this area is linked to.
@export var camera_behaviour_node: CameraBehaviourNode


func _ready():
	body_entered.connect(_on_anything_entered)
	area_entered.connect(_on_anything_entered)
	body_exited.connect(_on_anything_exited)
	area_exited.connect(_on_anything_exited)


func _on_anything_entered(node: Node3D):
	if node == player:
		if camera_behaviour_node:
			camera_behaviour_node.add_behaviour()


func _on_anything_exited(node: Node3D):
	if node == player:
		if camera_behaviour_node:
			camera_behaviour_node.remove_behaviour()
