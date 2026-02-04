extends CharacterBody2D

const MASS = 0.25

@onready var Collider = $Collider

var launched = false
var gravityvec = Vector2(0,10)
var mouse: Vector2
var arrow: Vector2

func _ready():
	pass 

func _process(delta):
	if launched && is_on_floor():
		#velocity += gravityvec*MASS
		#position += velocity*delta
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		# Update: delta is also needed here

func launch(mousePosition : Vector2, arrowPosition : Vector2):
	launched = true
	mouse = mousePosition
	arrow = arrowPosition
	var speed = mousePosition - arrowPosition
	var angle = speed.angle()
	velocity = Vector2(cos(angle), sin(angle))
