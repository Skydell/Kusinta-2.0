extends PlayerState

var lastWallDirection
var shouldEnableWallKick: bool

func EnterState():
	Name = "WallJump"
	Player.velocity.y = Player.WALLJUMPVELOCITY
	lastWallDirection = Player.wallDirection
	
	Player.velocity.x = Player.WALLJUMPHSPEED * Player.wallDirection.x * -1
	#print(Player.velocity.x)
	#ShouldOnlyJumpButtonWallKick(false) 

func ExitState():
	print("Exit Wall Jump State")

func Draw():
	pass

func Update(delta: float):
	Player.GetWallDirection() #For ending state if we hit a wall
	#Player.HandleGravity(delta, Player.GRAVITYJUMP)
	HandleWallKickMouvement(delta)
	HandleWallJumpEnd()
	HandleAnimations()

func ShouldOnlyJumpButtonWallKick(shouldEnable: bool):
	shouldEnableWallKick = shouldEnable
	if (shouldEnable):
		if (Player.keyRight or Player.keyLeft):
			Player.velocity.x = Player.WALLJUMPHSPEED * Player.wallDirection.x * -1 # Flip to bounce of the wall
		else:
			if (Player.jumps == Player.MAXNUMBEROFJUMPS):
				Player.velocity.x = Player.WALLJUMPHSPEED * Player.wallDirection.x * -1
			else:
				Player.ChangeState(States.Fall)
	else:
		Player.velocity.x = Player.WALLJUMPHSPEED * Player.wallDirection.x * -1

func HandleWallKickMouvement(delta: float):
	Player.velocity.x = move_toward(Player.velocity.x, 0, 50)
	
	#if ((!Player.keyLeft and !Player.keyRight) 
	#or ((lastWallDirection == Vector2.LEFT and Player.keyLeft)) 
	#or ((lastWallDirection == Vector2.RIGHT) and Player.keyRight)):
		## No input means wall kick, small mouvement to move slightly along the wall
		#Player.HorinzontalMouvement(200, 200)
		#Player.HandleGravity(delta, Player.GRAVITYKICK)
	#if ((lastWallDirection == Vector2.LEFT) and Player.keyRight) or ((lastWallDirection == Vector2.RIGHT) and Player.keyLeft):
		## move to opposite direction at full speed
		#Player.HorinzontalMouvement(Player.WALLKICKACCELERATION, Player.WALLKICKDECELERATION)
		#Player.HandleGravity(delta, Player.GRAVITYJUMP)
			

func HandleWallJumpEnd():
	# End if at jump peak
	if (Player.velocity.y >= Player.WALLJUMPYSPEEDPEAK):
		Player.ChangeState(States.Fall)
	#Cancel if we hit a wall
	if ((Player.wallDirection != lastWallDirection) and (Player.wallDirection != Vector2.ZERO)):
		Player.ChangeState(States.Fall)
		#
	#if ((!Player.keyLeft and !Player.keyRight) 
	#or ((lastWallDirection == Vector2.LEFT and Player.keyLeft)) 
	#or ((lastWallDirection == Vector2.RIGHT) and Player.keyRight)):
		#Player.ChangeState(States.Fall)

func HandleAnimations():
	if (!Player.keyLeft and !Player.keyRight and shouldEnableWallKick):
		Player.Animator.play("WallKick")
		# TODO flip ??
		Player.Sprite.flip_h = (Player.velocity.x > 0)
	else:
		Player.Animator.play("WallJump")
		# TODO flip ??
		Player.Sprite.flip_h = (Player.velocity.x > 0)
