extends ArrowState

func EnterState():
	Name = "Initial State"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	HandleLaunch()

func HandleLaunch():
	if (Arrow.launched):
		Arrow.ChangeState(ArrowStates.ForwardMotion)
