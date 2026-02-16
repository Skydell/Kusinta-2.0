extends ArrowState

func EnterState():
	Name = "Foward Motion"
	print("Velocity : "+str(Arrow.velocity))

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	Arrow.HandleMouvementForward()
	HandleCollision()
	

func HandleCollision():
	if (Arrow.collision):
		Arrow.ChangeState(ArrowStates.Idle)
