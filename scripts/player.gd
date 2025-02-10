extends CharacterBody2D


@export var speed = 400
var ball

func _ready():
	ball = get_parent().get_node("Ball")

func _physics_process(delta):
	
	velocity.x = 0
	if Input.is_action_pressed("MoveLeft") and ball.started == true:
		velocity.x -= speed
	if Input.is_action_pressed("MoveRight") and ball.started == true:
		velocity.x += speed
	
	move_and_collide(velocity * delta)
	
