extends PlayerState

func EnterState():
	Name = "Jump"
	Player.velocity.y = Player.jumpSpeed

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	# Jump mouvement
	Player.HandleGravity(delta)
	Player.HorinzontalMouvement()
	# JUMP -> JUMPPEAK
	HandleJumpToFall()
	# JUMP -> WALL SLIDE
	Player.HandleWallJump()
	HandleAnimations()

func HandleJumpToFall():
	if (Player.velocity.y >= 0):
		#print("Reached Peak !")
		Player.ChangeState(States.JumpPeak)
	if (!Player.keyJump):
		#print("Not pressing jump anymore")
		Player.velocity.y *= Player.VARIABLEJUMPMULTIPLIER
		Player.ChangeState(States.JumpPeak)

# KEPT for example of slowing down game for future shoot while jumping
#func HandleGameSlowDown():
	#if (Player.KeySpace):
		#if (Engine.time_scale != 0.5):
			#Engine.time_scale = 0.5
		#else:
			#Engine.time_scale = 1

func HandleAnimations():
	Player.Animator.play("Jump")
	Player.HandleFlipH()
