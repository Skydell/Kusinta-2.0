extends PlayerState

func EnterState():
	Name = "Run"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	# Handle mouvement
	Player.HorinzontalMouvement()
	# RUN -> JUMP
	Player.HandleJump()
	# RUN -> FALL
	Player.HandleFalling()
	# RUN -> IDLE
	HandleIdle()
	
	HandleAnimations()


func HandleAnimations():
	Player.Animator.play("Run")
	Player.HandleFlipH()
	
func HandleIdle():
	if (Player.velocity.x == 0):
		Player.ChangeState(States.Idle)
