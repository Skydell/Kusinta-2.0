extends PlayerState

const wallMagnetSpeed = 50
var lastWallDirection

func EnterState():
	Name = "WallSlide"
	Player.SlideStaminaTimer.start(Player.WALLSLIDESTAMINATIME)
	Player.GetWallDirection()
	lastWallDirection = Player.wallDirection
	Player.jumps = 0
	# Move the player to the wall to avoid space between player and wall
	if (Player.wallDirection == Vector2.LEFT):
		Player.velocity.x = - wallMagnetSpeed
	elif (Player.wallDirection == Vector2.RIGHT):
		Player.velocity.x = wallMagnetSpeed

func ExitState():
	Player.CoyoteTimer.start(Player.WALLJUMPCOYOTETIME)
	Player.SlideStaminaTimer.stop()

func Draw():
	pass

func Update(delta: float):
	HandleWallSlideMouvement()
	Player.HandleWallJump()
	Player.HandleLanding()
	HandleWallFallFromOppositeDirection()
	HandleAnimations()

func HandleWallSlideMouvement():
	if ((Player.RCWallSlideTopRight.is_colliding() and Player.RCWallJumpBottonRight.is_colliding())	
	or (Player.RCWallSlideTopLeft.is_colliding() and Player.RCWallJumpBottomLeft.is_colliding())):
		if (Player.SlideStaminaTimer.time_left > 0):
			Player.velocity.y = Player.WALLSLIDESPEED
		else:
			Player.global_position.x += 4 * Player.wallDirection.x * -1
			Player.ChangeState(States.Fall)

func HandleWallFallFromOppositeDirection():
	if (!Player.RCWallJumpBottonRight.is_colliding() and !Player.RCWallJumpBottomLeft.is_colliding()):
		Player.ChangeState(States.Fall)
	
	if ((Player.RCWallSlideTopRight.is_colliding() and Player.RCWallJumpBottonRight.is_colliding() and Player.keyLeft)
	or (Player.RCWallSlideTopLeft.is_colliding() and Player.RCWallJumpBottomLeft.is_colliding() and Player.keyRight)):
		Player.global_position.x += 4 * Player.wallDirection.x * -1
		Player.ChangeState(States.Fall)

func HandleAnimations():
	Player.Animator.play("WallSlide")
	Player.Sprite.flip_h = (Player.wallDirection == Vector2.LEFT)
