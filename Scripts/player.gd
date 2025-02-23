extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D  # Referencia al AnimatedSprite2D
@onready var _coins_collected_label = get_parent().get_node("CoinsCollectedLabel")
@onready var _timer = get_parent().get_parent().get_node("Node2D")

@onready var _coin_sound = $CoinSound
var coins_collected = 0
var total_coins = 8

func _physics_process(delta: float) -> void:
	# gravedad.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Manejar salto.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Obtener la dirección de movimiento (izquierda/derecha y arriba/abajo)
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		animated_sprite.play("walk") 
		animated_sprite.flip_h = true  # voltear 
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
		animated_sprite.play("walk")  
		animated_sprite.flip_h = false  # izq
	elif Input.is_action_pressed("ui_down"):
		direction.y += 1
		animated_sprite.play("walk_down")  
		animated_sprite.rotation_degrees = 180  # bajar
	elif Input.is_action_pressed("ui_up"):
		direction.y -= 1
		animated_sprite.play("walk_down")  
		animated_sprite.rotation_degrees = 0  # subir
	else:
		animated_sprite.play("idle_down")  # quieto
		animated_sprite.rotation_degrees = 0  

	# Movimiento del personaje
	if direction != Vector2.ZERO:
		direction = direction.normalized()  # Normalizar la dirección para que la velocidad no sea mayor en diagonal

	velocity.x = direction.x * SPEED  # Movimiento horizontal
	velocity.y = direction.y * SPEED  # Movimiento vertical

	move_and_slide()

	


func _on_finished_line_body_entered(body: Node2D) -> void:
	if coins_collected == 8 and _timer.time > 0:
		get_tree().change_scene_to_file("res://scenes/winner_screen.tscn")
	
