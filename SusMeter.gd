extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.connect("group_sus_changed", self, "set_sus_meter")

func set_sus_meter(new_sus):
	text = str(new_sus)
