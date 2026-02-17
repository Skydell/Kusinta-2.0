extends ArrowState

func EnterState():
	Name = "Idle"
	Arrow.RecallHitBox.set_deferred("disabled", false)

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	pass
