extends Area2D

@export var speed = 140
@export var rotation_speed = 1.3
@onready var timer_delete = $TimerDelete
@onready var audioCollisionBall: AudioStreamPlayer2D = $AudioCollisionBall
@onready var asteroidSprite: Sprite2D = $Sprite2D

var startSide

func _ready():
	if (global_position.x > 540):
		startSide = "right"
		
	else:
		startSide = "left"

func _process(delta):
	if (startSide == "right"):
		global_position.x -= speed * delta
		rotation -= rotation_speed * delta
	elif (startSide == "left"):
		global_position.x += speed * delta
		rotation += rotation_speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer_delete.start()


func _on_timer_delete_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.pongs += 1
	audioCollisionBall.play()
	asteroidSprite.visible = false


func _on_audio_collision_ball_finished() -> void:
	queue_free()
