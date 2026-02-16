class_name ArrowProjectile extends CharacterBody2D

@onready var Collider = $Collider
@onready var ArrowStates = $ArrowStateMachine
var Player : PlayerCharacter = null

# State Machine
var currentState: ArrowState = null
var previousState: ArrowState = null

const MASS = 0.25

var gravity = 5
var shotStrength: float
var launched: bool = false
var velocityForward: Vector2
var velocityBackWard: Vector2
var collision: KinematicCollision2D

func _ready() -> void:
	# Initialize State Machine
	for state in ArrowStates.get_children():
		print(state.name)
		state.ArrowStates = ArrowStates
		state.Arrow = self
	previousState = ArrowStates.InitialState
	currentState = ArrowStates.InitialState

func _draw() -> void :
	currentState.Draw()

func _physics_process(delta: float) -> void:	
	# Update current State
	currentState.Update(delta)

func ChangeState(newState: ArrowState):
	if (newState != null):
		previousState = currentState
		currentState = newState
		previousState.ExitState()
		currentState.EnterState()
		# Not sure why we need to return here
		return

func HandleMouvementForward():
	if (gravity > 0):
		velocityForward.y += gravity * MASS 
	# Commit mouvement
	rotation = velocityForward.angle()
	collision = move_and_collide(velocityForward)
	
func HandleMouvementBackward():
	rotation = velocityBackWard.angle()
	collision = move_and_collide(velocityBackWard)

func Launch(mousePosition : Vector2, playerPosition : Vector2, strength : float, arrowGravityModifier : float):
	shotStrength = strength
	var speed = mousePosition - playerPosition
	var angle = speed.angle()
	if (arrowGravityModifier >= 5):
		gravity = 0
	else:
		gravity -= arrowGravityModifier
	velocityForward = Vector2(cos(angle)*shotStrength, sin(angle)*shotStrength)
	rotation = velocityForward.angle()
	launched = true

func Recall(playerPosition: Vector2, arrowPosition: Vector2):
	var speed = playerPosition - arrowPosition
	var angle = speed.angle()
	velocityBackWard = Vector2(cos(angle)*12, sin(angle)*12)
	ChangeState(ArrowStates.BackToPlayerMotion)
	
