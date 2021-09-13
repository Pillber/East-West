extends VBoxContainer

signal play_pressed()

func _on_PlayButton_pressed():
	print("playing...")
	emit_signal("play_pressed")


func _on_OptionsButton_pressed():
	print("options...")


func _on_QuitButton_pressed():
	print("quiting...")
	get_tree().quit()
