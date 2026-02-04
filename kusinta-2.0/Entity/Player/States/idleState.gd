extends PlayerState

func EnterState():
	Name = "Idle"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	# If player gets pushed of a ledge: ILDE -> FALL
	Player.HandleFalling()
	# Register inputs to transition to the right State
	# IDLE -> JUMP
	Player.HandleJump()
	# IDLE -> RUN
	HandleRun()
	# IDLE -> Shoot
	HanleShootCharge()

	HandleAnimations()

func HandleRun():
	Player.moveDirectionX = Input.get_axis("KeyLeft", "KeyRight")
	if (Player.moveDirectionX != 0):
		Player.ChangeState(States.Run)

func HandleAnimations():
	Player.Animator.play("Idle")
	Player.HandleFlipH()
	
func HanleShootCharge():
	if (Player.KeyMouseLeftClickHold && Player.remainingArrowsInQuiver > 0):
		Player.ChangeState(States.ChargeShot)
	
