extends ArrowState

func EnterState():
	Name = "Back To Player Motion"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	Arrow.HandleMouvementBackward()
