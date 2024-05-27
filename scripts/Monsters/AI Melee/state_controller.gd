extends Node

var state = {
	"Idle": preload("res://scripts/Monsters/AI Melee/idle_state.gd"),
	"Attack": preload("res://scripts/Monsters/AI Melee/attack_state.gd"),
	"Run": preload("res://scripts/Monsters/AI Melee/run_state.gd"),
	"Death": preload("res://scripts/Monsters/AI Melee/death_state.gd"),
}

func change_state(new_state:String):
	if(get_child_count() != 0):
		get_child(0).queue_free()
	if(state.has(new_state)):
		var state_temp = state[new_state].new()
		state_temp.name = new_state
		add_child(state_temp)
