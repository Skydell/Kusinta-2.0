extends PlayerState

var horizontalVelocity
var lastWallDirection
var shouldEnableWallKick: bool

func EnterState():
	Name = "WallJump"
	lastWallDirection = Player.wallDirection
	Player.velocity.y = Player.WALLJUMPVELOCITY

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	Player.GetWallDirection() #For ending state if we hit a wall
	HandleWallKickMouvement(delta)
	Player.HandleGravity(delta)
	HandleWallJumpEnd()
	HandleAnimations()

func HandleWallKickMouvement(delta: float):
	if ((lastWallDirection == Vector2.LEFT and Player.keyRight) 
	or (lastWallDirection == Vector2.RIGHT and Player.keyLeft)):
		horizontalVelocity = Player.WALLJUMPHSPEED * lastWallDirection.x * -1
	else:
		horizontalVelocity = Player.WALLJUMPHSPEED * 0.5 * lastWallDirection.x * -1 # 50%
	Player.velocity.x = move_toward(Player.velocity.x, horizontalVelocity, Player.AIRACCELERATION)


func HandleWallJumpEnd():
	# End if at jump peak
	if (Player.velocity.y >= Player.WALLJUMPYSPEEDPEAK):
		Player.ChangeState(States.Fall)
	#Cancel if we hit a wall
	if ((Player.wallDirection != lastWallDirection) and (Player.wallDirection != Vector2.ZERO)):
		Player.ChangeState(States.Fall)

func HandleAnimations():
	Player.Animator.play("WallJump")
	# TODO flip ??
	Player.Sprite.flip_h = (Player.velocity.x > 0)
