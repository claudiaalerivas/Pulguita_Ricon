extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D  # Referencia al AnimatedSprite2D
@onready var _coins_collected_label = get_parent().get_node("CoinsCollectedLabel")
@onready var _timer = get_parent().get_parent().get_node("Node2D")
@onready var pause_button = get_parent().get_node("PauseButton")
@onready var  pause_menu_scene = load("res://scenes/pause_menu.tscn")


@onready var _coin_sound = $CoinSound
var coins_collected = 0
var total_coins = 8
var pause_menu
var is_paused = false

func _ready():
	pause_menu = pause_menu_scene.instantiate()
	add_child(pause_menu)  

	pause_menu.player = self
	await get_tree().process_frame
	_add_pause_menu()
	pause_menu.visible = false
	pause_button.pressed.connect(pause_game)

func _add_pause_menu():
	if pause_menu.get_parent(): 
		pause_menu.get_parent().remove_child(pause_menu)
	get_tree().current_scene.add_child(pause_menu) 
	pause_menu.visible = false
	
func _input(event):
	if event.is_action_pressed("ui_cancel"): 
		if is_paused:
			resume_game()  
		else:
			pause_game()  

func pause_game():
	is_paused = true
	pause_menu.visible = true
	pause_menu.show_pause_menu()
	get_tree().paused = true


func resume_game():
	is_paused = false
	pause_menu.hide_pause_menu()  
	get_tree().paused = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# (izquierda/derecha y arriba/abajo)
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
		call_deferred("change_scene")

func change_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/winner_screen.tscn")
	
