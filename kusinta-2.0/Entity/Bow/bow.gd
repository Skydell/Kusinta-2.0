class_name BowWeapon extends Node2D

@onready var Animator = $AnimationPlayer
@onready var BowStates = $"State Machine"
@onready var Sprite = $Sprite2D

#For Arrow shooting
@onready var ArrowPlacement = $"Arrow Placement"
@onready var ArrowScene = preload("res://Entity/Arrow/arrow.tscn")
var ArrowList: Array[ArrowProjectile] = []

# Arrow Management
const MAXARROWSINQUIVER = 10
var remainingArrowsInQuiver = MAXARROWSINQUIVER

# State Machine
var currentState: BowState = null
var previousState: BowState = null

# Manage inputs
var KeyMouseLeftClickHold = false
var KeyMouseLeftClickRelease = false
var KeyMouseRightClickPressed = false

func _ready() -> void:
	# Initialize State Machine
	for state in BowStates.get_children():
		state.BowStates = BowStates
		state.Bow = self
	previousState = BowStates.Idle
	currentState = BowStates.Idle

func _draw() -> void :
	currentState.Draw()

func _physics_process(delta: float) -> void:	
	# Get Inputs states
	GetInputStates()
	look_at(get_global_mouse_position())
	# Update current State
	currentState.Update(delta)


func ChangeState(newState: BowState):
	if (newState != null):
		previousState = currentState
		currentState = newState
		previousState.ExitState()
		currentState.EnterState()
		print("Bow State : "+currentState.Name + " with Older state: "+ previousState.Name)
		# Not sure why we need to return here
		return

func GetInputStates():
	KeyMouseLeftClickHold = Input.is_action_just_pressed("Shoot")
	KeyMouseLeftClickRelease = Input.is_action_just_released("Shoot")
	KeyMouseRightClickPressed = Input.is_action_pressed("Recall")

func Disable():
	if (currentState != BowStates.Disable):
		ChangeState(BowStates.Disable)

func Enable():
	if (currentState != BowStates.Idle):
		ChangeState(BowStates.Idle)

func HandleRecall():
	if (KeyMouseRightClickPressed):
		ChangeState(BowStates.ChooseArrowToRecall)
