class_name PlayerCharacter extends CharacterBody2D

#region Player Variables

# Nodes
@onready var Sprite = $Sprite
@onready var Collider = $Collider
@onready var Animator = $Animator
@onready var Camera = $Camera
@onready var States = $StateMachine
@onready var JumpBufferTimer = $Timers/JumpBufferTimer
@onready var CoyoteTimer = $Timers/CoyoteTimer
@onready var WallJumpBufferTimer = $Timers/WallJumpBufferTimer

@onready var Raycasts = $Raycasts
@onready var RCWallJumpBottomLeft = $Raycasts/WallJump/WallJumpLeft
@onready var RCWallJumpBottonRight = $Raycasts/WallJump/WallJumpRight
@onready var RCWallSlideTopLeft = $Raycasts/WallSlide/WallSlideLeft
@onready var RCWallSlideTopRight = $Raycasts/WallSlide/WallSlideRight

@onready var RCLedgeGrabRightLower = $Raycasts/LedgeGrab/LedgeRightLower
@onready var RCLedgeGrabRightUpper = $Raycasts/LedgeGrab/LedgeRightUpper
@onready var RCLedgeGrabLeftLower = $Raycasts/LedgeGrab/LedgeLeftLower
@onready var RCLedgeGrabLeftUpper = $Raycasts/LedgeGrab/LedgeLeftUpper

# Bow
@onready var Bow : BowWeapon = $Bow

# Used to get the tilemap for snapping
@export var CollisionMap: TileMapLayer

# Physics var
const RUNSPEED = 120 
const GROUNDACCELERATION = 40
const GROUNDDECELERATION = 35
const AIRACCELERATION = 15
const AIRDECELERATION = 20

const GRAVITYJUMP = 600
const GRAVITYFALL = 750
const GRAVITYKICK = 800
const MAXFALLVELOCITY = 400
const WALLSLIDESPEED = 40
const JUMPSPEED = -260
const VARIABLEJUMPMULTIPLIER = 0.6
const MAXNUMBEROFJUMPS = 1
const JUMPBUFFERTIME = 0.15 # 9 frames: FPS / (desired frames) = time in seconds
const COYOTETIME = 0.1  # 6 frames
const WALLJUMPCOYOTETIME = 0.15 # 9 frames: FPS / (desired frames) = time in seconds

const WALLJUMPYSPEEDPEAK = 0 # Y speed at which the wall jump will end and change to fall
const WALLJUMPVELOCITY = -220
const WALLJUMPHSPEED = 120

var moveSpeed = RUNSPEED
var jumpSpeed = JUMPSPEED
var moveDirectionX = 0
var jumps = 0
var wallDirection: Vector2 = Vector2.ZERO
var ledgeDiection: Vector2 = Vector2.ZERO
var facing = 1

# Input variables
var keyUp = false
var keyDown = false
var keyLeft = false
var keyRight = false
var keyJump = false
var KeyJumpPressed = false
var KeyUpPressed = false
var KeyMouseLeftClickHold = false
var KeyMouseLeftClickRelease = false

# State Machine
var currentState: PlayerState = null
var previousState: PlayerState = null

# Pausing game
var cancelMotion: bool = false

#endregion

#region Main Loop Functions

func _ready() -> void:
	# Initialize State Machine
	for state in States.get_children():
		state.States = States
		state.Player = self
	previousState = States.Fall
	currentState = States.Fall

func _draw() -> void :
	currentState.Draw()

func _physics_process(delta: float) -> void:
	# Get Inputs states
	GetInputStates()
	UpdateRaycasts()
	
	# Update current State
	currentState.Update(delta)
	
	# Commit mouvement
	if (!cancelMotion):
		move_and_slide()

func ChangeState(newState: PlayerState):
	if (newState != null):
		previousState = currentState
		currentState = newState
		previousState.ExitState()
		currentState.EnterState()
		# Not sure why we need to return here
		return

func UpdateRaycasts():
	for child in Raycasts.get_children():
		if child is RayCast2D:
			child.force_raycast_update()

#endregion

#region Custom Functions

func GetWallDirection():
	if (RCWallJumpBottonRight.is_colliding()):
		wallDirection = Vector2.RIGHT
	elif (RCWallJumpBottomLeft.is_colliding()):
		wallDirection = Vector2.LEFT
	else:
		wallDirection = Vector2.ZERO

func GetInputStates():
	keyUp = Input.is_action_pressed("KeyUp")
	keyDown = Input.is_action_pressed("KeyDown")
	keyLeft = Input.is_action_pressed("KeyLeft")
	keyRight = Input.is_action_pressed("KeyRight")
	keyJump = Input.is_action_pressed("KeyJump")
	KeyJumpPressed = Input.is_action_just_pressed("KeyJump")
	KeyUpPressed = Input.is_action_just_pressed("KeyUp")
	KeyMouseLeftClickHold = Input.is_action_just_pressed("Shoot")
	KeyMouseLeftClickRelease = Input.is_action_just_released("Shoot")
	
	if (keyRight): facing = 1
	if (keyLeft): facing = -1

func HorinzontalMouvement(acceleration: float = GROUNDACCELERATION, deceleration: float = GROUNDDECELERATION):
	moveDirectionX = Input.get_axis("KeyLeft", "KeyRight")
	if (moveDirectionX != 0):
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, deceleration)

func HandleFalling():
	# Check if we got off a ledge, if so change state to falling
	if(!is_on_floor()):
		# Start our Coyote Timer
		CoyoteTimer.start(COYOTETIME)
		ChangeState(States.Fall)

func HandleLanding():
	if (is_on_floor()):
		jumps = 0
		if (velocity.x != 0):
			ChangeState(States.Run)
		else:
			ChangeState(States.Idle)

func HandleWallSlide():
	# TODO rewrite this methode removing code from wall direction
	GetWallDirection()
	if ((wallDirection == Vector2.LEFT
	and RCWallSlideTopLeft.is_colliding() 	
	and RCWallJumpBottomLeft.is_colliding()) or 	
	(wallDirection == Vector2.RIGHT
	and RCWallSlideTopRight.is_colliding() 	
	and RCWallJumpBottonRight.is_colliding())):
		ChangeState(States.WallSlide)

func HandleJump():
	if (is_on_floor()):
		if (jumps < MAXNUMBEROFJUMPS):
			if (KeyJumpPressed or (JumpBufferTimer.time_left > 0)):
				jumps += 1
				JumpBufferTimer.stop()
				ChangeState(States.Jump)
	else:
		# Handle air jumps if Max Jumps > 1 (first jump from ground)
		if ((jumps < MAXNUMBEROFJUMPS) and (jumps > 0) and KeyJumpPressed):
			jumps += 1
			ChangeState(States.Jump)
		# Handle Coyote Time
		elif (CoyoteTimer.time_left > 0 and (jumps < MAXNUMBEROFJUMPS) and KeyJumpPressed):
			CoyoteTimer.stop()
			jumps += 1
			ChangeState(States.Jump)
		elif (WallJumpBufferTimer.time_left > 0 and (jumps < MAXNUMBEROFJUMPS)	 
		and ((keyLeft and wallDirection == Vector2.RIGHT)	
		or (keyRight and wallDirection == Vector2.LEFT))):
			WallJumpBufferTimer.stop()
			jumps += 1
			ChangeState(States.Jump)

func HandleJumpBuffer():
	if (KeyJumpPressed):
		JumpBufferTimer.start(JUMPBUFFERTIME)

func HandleWallJump():
	GetWallDirection()
	# If we are against a wall
	if (wallDirection != Vector2.ZERO):
		if (KeyJumpPressed or JumpBufferTimer.time_left > 0 and jumps < MAXNUMBEROFJUMPS):
			JumpBufferTimer.stop()
			jumps += 1
			ChangeState(States.WallJump)
	# If we are in the air
	else:
		if (KeyJumpPressed and CoyoteTimer.time_left > 0 and jumps < MAXNUMBEROFJUMPS):
			CoyoteTimer.stop()
			jumps += 1
			ChangeState(States.WallJump)

func HandleLedgeGrab(): 
	if (RCLedgeGrabLeftLower.is_colliding() and !RCLedgeGrabLeftUpper.is_colliding()):
		if (facing == -1): # can add another if for non auto snap
			velocity = Vector2.ZERO
			ChangeState(States.LedgeGrab)
	elif (RCLedgeGrabRightLower.is_colliding() and !RCLedgeGrabRightUpper.is_colliding()):
		if (facing == 1): # can add another if for non auto snap
			velocity = Vector2.ZERO
			ChangeState(States.LedgeGrab)

func HandleGravity(delta, gravity: float = GRAVITYJUMP):
	if (!is_on_floor()):
		velocity.y += gravity * delta
		# Limit falling speed to a max
		if (velocity.y > MAXFALLVELOCITY):
			velocity.y = MAXFALLVELOCITY

func HandleFlipH():
	# Flip Sprite
	Sprite.flip_h = (facing < 0)

#endregion
