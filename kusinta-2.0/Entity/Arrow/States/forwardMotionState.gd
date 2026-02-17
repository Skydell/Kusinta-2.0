extends ArrowState

func EnterState():
	Name = "Foward Motion"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	Arrow.HandleMouvementForward()
	Arrow.HandleCollision()
