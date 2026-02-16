extends BowState

func EnterState():
	Name = "Disable"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	HandleAnimations()

func HandleAnimations():
	Bow.hide()
