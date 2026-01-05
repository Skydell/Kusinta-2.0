extends PlayerState

func EnterState():
	Name = "WallSlideCharge"
	Player.WallJumpBufferTimer.start(Player.WALLJUMPBUFFERTIME)

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	HandleWallSlideMouvement()
	Player.HandleWallJump()
	Player.HandleLanding()
	HandleEndOfTimer()
	HandleWallFallFromOppositeDirection()
	HandleAnimations()

func HandleWallSlideMouvement():
	if ((Player.RCWallSlideTopRight.is_colliding() and Player.RCWallJumpBottonRight.is_colliding())	
	or (Player.RCWallSlideTopLeft.is_colliding() and Player.RCWallJumpBottomLeft.is_colliding())):
		Player.velocity.y = Player.WALLSLIDESPEEDBEFOREJUMP

func HandleWallFallFromOppositeDirection():
	if (!Player.RCWallJumpBottonRight.is_colliding() and !Player.RCWallJumpBottomLeft.is_colliding()):
		Player.ChangeState(States.Fall)
	
	if ((Player.RCWallSlideTopRight.is_colliding() and Player.RCWallJumpBottonRight.is_colliding() and Player.keyLeft)
	or (Player.RCWallSlideTopLeft.is_colliding() and Player.RCWallJumpBottomLeft.is_colliding() and Player.keyRight)):
		print("Going to jump")
		Player.ChangeState(States.Jump)

func HandleEndOfTimer():
	if (Player.WallJumpBufferTimer.time_left == 0):
		Player.ChangeState(States.WallSlide)
		Player.WallJumpBufferTimer.stop()

func HandleAnimations():
	Player.Animator.play("WallSlide")
	Player.Sprite.flip_h = (Player.wallDirection == Vector2.LEFT)
