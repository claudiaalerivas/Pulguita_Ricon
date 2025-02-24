extends Control

func _ready() -> void:
	$GeneralSound.play()
	
func _on_play_button_pressed() -> void:
	$GeneralSound.stop()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_get_out_button_pressed() -> void:
	get_tree().quit()


func _on_credit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
