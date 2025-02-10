extends CharacterBody2D


var started = false
var startSpeed = 500
var incrementalSpeed = 1.02
var angle = [-250, 250]
var pongs = 0
var maxSpeed = 1500
@onready var audioImpact = $AudioImpact

func _physics_process(delta):
	if Input.is_action_pressed("Start") and started == false:
		startGame()
		
	if started:
		var collision = move_and_collide(velocity*delta)
		if collision != null:
			audioImpact.play()
			if collision.get_collider().name == "TopWall":
				pongs += 1
				if velocity.length() > maxSpeed:
					velocity = velocity.bounce(collision.get_normal())
				else:
					velocity = velocity.bounce(collision.get_normal()) * incrementalSpeed
			else:
				velocity = velocity.bounce(collision.get_normal())
	

func startGame():
	started = true
	velocity.y = -startSpeed
	velocity.x = angle.pick_random()
	
