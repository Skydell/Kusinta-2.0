extends BowState

func EnterState():
	Name = "Idle"
	Bow.show()

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	HanleChargeShot()
	Bow.HandleRecall()
	HandleAnimations()

func HandleAnimations():
	Bow.Animator.play("Idle")

func HanleChargeShot():
	if (Bow.KeyMouseLeftClickHold && Bow.remainingArrowsInQuiver > 0):
		Bow.ChangeState(BowStates.Charge)
