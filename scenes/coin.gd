extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("rotation")
	print("Iniciando animación")




func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.coins_collected += 1
		body._coins_collected_label.text = str(body.coins_collected)
		# body._coin_sound.play()
		queue_free()
