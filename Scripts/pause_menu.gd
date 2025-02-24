extends CanvasLayer
@onready var coins_label = $Background/CoinsLabel

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	

func show_pause_menu():
	$GeneralSound.play()
	visible = true
	get_tree().paused = true
	if player:
		coins_label.text = str(player.coins_collected)

func _on_resume_button_pressed() -> void:
	$GeneralSound.stop()
	get_tree().paused = false
	visible = false

func _on_new_game_button_pressed() -> void:
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
