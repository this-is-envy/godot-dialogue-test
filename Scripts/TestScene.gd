extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass


func toast_entered(area: Area2D) -> void:
	var player: Player = area.get_parent()
	player.set_engaged(true)
	DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/Gauntlet.dialogue"), 'start_enter')

func toast_exited(area: Area2D) -> void:
	var player: Player = area.get_parent()
	player.set_engaged(true)
	DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/Gauntlet.dialogue"), 'start_exit')

func gauntlet_enter(area: Area2D) -> void:
	State.gauntlet_passed = true