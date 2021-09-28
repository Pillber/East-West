extends CanvasLayer

onready var sus_meter = $SusMeter
onready var loyalist_label = $LoyalistLabel
onready var escapee_label = $EscapeeLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.connect("group_sus_changed", self, "set_sus_meter")
	
	if is_network_master():
		if get_parent().team == GameState.TEAM.LOYALIST:
			loyalist_label.visible = true
		else:
			escapee_label.visible = true
		

func set_sus_meter(new_sus):
	sus_meter.value = new_sus
