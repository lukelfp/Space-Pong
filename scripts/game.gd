extends Node2D

@onready var ball = $Ball
@onready var labelPongs = $Pongs
@onready var labelTutorial = $Tutorial
@onready var positions = $Positions
@onready var controllerTutorial = $ControllerTutorial
@onready var gameOverMessage = $GameOverMessage
@onready var background = $Background
@onready var finalScoreMessage: Label = $FinalScoreMessage
@onready var finalScoreNumber: Label = $FinalScoreNumber
@onready var audioLevelUp: AudioStreamPlayer2D = $AudioLevelUp
@onready var backgroundSound: AudioStreamPlayer2D = $BackgroundSound
var lastPosition
var asteroidScene = preload("res://scenes/asteroid.tscn")
var gameOver = false


var resourceAsteroids = {}
var resourceBackgrounds = {}
var resourceColorsLabel = {}

var newAsteroidColor

var lastPongs = -1

func _ready():
	preloadResoures()
	pass

func _process(delta):
	if ball.started == true and gameOver == false:
		labelTutorial.visible = false
		controllerTutorial.visible = false
		labelPongs.visible = true
		checkPongs(ball.pongs)
	labelPongs.text = str(ball.pongs)
	finalScoreNumber.text = str(ball.pongs)
	
	if gameOver == true and Input.is_action_pressed("Restart"):
		call_deferred("reload_scene")

func _on_hole_body_entered(body: Node2D):
	labelPongs.visible = false
	gameOverMessage.visible = true
	finalScoreMessage.visible = true
	finalScoreNumber.visible = true
	gameOver = true
	backgroundSound.stop()
	
	
func reload_scene():
	get_tree().reload_current_scene()


func _on_timer_spawner_timeout() -> void:
	spawnAsteroids()
	
func spawnAsteroids():
	if (ball.started and gameOver == false):
		var positionsList = positions.get_children()
		var spawnPosition = positionsList.pick_random()
			
		if(spawnPosition != lastPosition):
			var asteroidInstance = asteroidScene.instantiate()
			asteroidInstance.global_position = spawnPosition.position
			if newAsteroidColor != null:
				asteroidInstance.get_node("Sprite2D").texture = newAsteroidColor
			add_child(asteroidInstance)
			lastPosition = spawnPosition
		else:
			spawnAsteroids()

func preloadResoures():
	resourceAsteroids = {
		"asteroid1": preload("res://sprites/Asteroide1.png"),
		"asteroid2": preload("res://sprites/Asteroide2.png"),
		"asteroid3": preload("res://sprites/Asteroide3.png"),
		"asteroid4": preload("res://sprites/Asteroide4.png"),
		"asteroid5": preload("res://sprites/Asteroide5.png"),
		"asteroid6": preload("res://sprites/Asteroide6.png")
	}
	
	resourceBackgrounds = {
		"background1": preload("res://sprites/Fundo1.png"),
		"background2": preload("res://sprites/Fundo2.png"),
		"background3": preload("res://sprites/Fundo3.png"),
		"background4": preload("res://sprites/Fundo4.png"),
		"background5": preload("res://sprites/Fundo5.png"),
		"background6": preload("res://sprites/Fundo6.png")
	}
	
	resourceColorsLabel = {
		"color1": "5d00c5",
		"color2": "4196ff",
		"color3": "4ea771",
		"color4": "fe9c35",
		"color5": "ff5d5d",
		"color6": "762d79",
	}

func checkPongs(pongs):
	if pongs != lastPongs and pongs % 10 == 0:
		match pongs:
			0:
				updateColors("color1", "background1")
			10:
				updateColors("color2", "background2")
				updateAsteroids("asteroid2")
			20: 
				updateColors("color3", "background3")
				updateAsteroids("asteroid3")
			30:
				updateColors("color4", "background4")
				updateAsteroids("asteroid4")
			40:
				updateColors("color5", "background5")
				updateAsteroids("asteroid5")
				
			50:
				updateColors("color6", "background6")
				updateAsteroids("asteroid6")
		lastPongs = pongs
		if pongs != 0:
			audioLevelUp.play()

func updateColors(keyColorLabel, keyColorBg):
	labelPongs.label_settings.font_color = resourceColorsLabel[keyColorLabel]
	background.set_texture(resourceBackgrounds[keyColorBg])
	
func updateAsteroids(keyAsteroid):
	var asteroids = get_tree().get_nodes_in_group("asteroids")
	
	for asteroid in asteroids:
		asteroid.get_node("Sprite2D").texture = resourceAsteroids[keyAsteroid]
		
	newAsteroidColor = resourceAsteroids[keyAsteroid]
