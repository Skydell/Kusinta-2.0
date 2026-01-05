extends PlayerState

func EnterState():
	# State used to avoid magnet from wall slide before falling
	Name = "UnMagnetState"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	# Falling + sideway mouvements while falling
	Player.HandleGravity(delta, Player.GRAVITYFALL)
	HandleUnmagnetHorizontalMouvement()
	# UNMAGNET -> FALL
	HandleUnmagnetToFall()
	
	# Handle Jump inputs before landing UNMAGNET -> IDLE OR RUN -> JUMP
	Player.HandleJumpBuffer()
	# handle Double Jumps UNMAGNET -> JUMP
	Player.HandleJump()
	
	# Handle Transition: UNMAGNET -> IDLE OR RUN (Depending on speed)
	Player.HandleLanding()

	HandleAnimations()

func HandleUnmagnetHorizontalMouvement():
	if (Player.RCWallJumpBottonRight.is_colliding() or Player.RCWallJumpBottomLeft.is_colliding()):
		Player.HorinzontalMouvement(Player.WALLKICKACCELERATION, Player.WALLKICKDECELERATION)

func HandleUnmagnetToFall():
	if (!Player.RCWallJumpBottonRight.is_colliding() and !Player.RCWallJumpBottomLeft.is_colliding()):
		Player.ChangeState(States.Fall)

func HandleAnimations():
	Player.Animator.play("Fall")
	Player.HandleFlipH()
