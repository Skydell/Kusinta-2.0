extends PlayerState

func EnterState():
	Name = "Fall"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	# Falling + sideway mouvements while falling
	Player.HandleGravity(delta, Player.GRAVITYFALL)
	Player.HorinzontalMouvement(Player.AIRACCELERATION, Player.AIRDECELERATION)
	
	# Handle Transition: FALL -> IDLE OR RUN (Depending on speed)
	Player.HandleLanding()
	# Handle Jump inputs before landing FALL -> IDLE OR RUN -> JUMP
	Player.HandleJumpBuffer()
	# handle Double Jumps FALL -> JUMP
	Player.HandleJump()
	# FALL -> WALL JUMP
	Player.HandleWallJump()
	# FALL -> WALL SLIDE
	Player.HandleWallSlide()
	# Falls -> LEDGE GRAB
	Player.HandleLedgeGrab()

	HandleAnimations()

func HandleAnimations():
	Player.Animator.play("Fall")
	Player.HandleFlipH()
