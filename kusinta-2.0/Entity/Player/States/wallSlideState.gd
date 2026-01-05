extends PlayerState

const wallMagnetSpeed = 50
var lastWallDirection

func EnterState():
	Name = "WallSlide"
	Player.GetWallDirection()
	lastWallDirection = Player.wallDirection
	#print(Player.CoyoteTimer.time_left)
	Player.jumps = 0
	# Move the player to the wall to avoid space between player and wall
	if (Player.wallDirection == Vector2.LEFT):
		Player.velocity.x = - wallMagnetSpeed
	elif (Player.wallDirection == Vector2.RIGHT):
		Player.velocity.x = wallMagnetSpeed

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	HandleWallSlideMouvement()
	#HandleJumpsFromWall()
	Player.HandleWallJump()
	#Player.HandleWallSlideCharge()
	Player.HandleLanding()
	HandleWallFallFromOppositeDirection()
	HandleAnimations()

func HandleWallSlideMouvement():
	if ((Player.RCWallSlideTopRight.is_colliding() and Player.RCWallJumpBottonRight.is_colliding())	
	or (Player.RCWallSlideTopLeft.is_colliding() and Player.RCWallJumpBottomLeft.is_colliding())):
		Player.velocity.y = Player.WALLSLIDESPEED

func HandleWallFallFromOppositeDirection():
	if (!Player.RCWallJumpBottonRight.is_colliding() and !Player.RCWallJumpBottomLeft.is_colliding()):
		Player.ChangeState(States.Fall)
	
	if ((Player.RCWallSlideTopRight.is_colliding() and Player.RCWallJumpBottonRight.is_colliding() and Player.keyLeft)
	or (Player.RCWallSlideTopLeft.is_colliding() and Player.RCWallJumpBottomLeft.is_colliding() and Player.keyRight)):
		Player.ChangeState(States.WallUnmagnet)

func HandleAnimations():
	Player.Animator.play("WallSlide")
	Player.Sprite.flip_h = (Player.wallDirection == Vector2.LEFT)
