extends VBoxContainer

onready var button_sound = $ButtonSound

signal play_pressed()

func _on_PlayButton_pressed():
	print("playing...")
	$ThemeMusic.stop()
	button_sound.play()
	emit_signal("play_pressed")


func _on_OptionsButton_pressed():
	print("options...")
	button_sound.play()


func _on_QuitButton_pressed():
	print("quiting...")
	button_sound.play()
	yield(button_sound, "finished")
	get_tree().quit()
