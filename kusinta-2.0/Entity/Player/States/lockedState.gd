extends PlayerState

func EnterState():
	Name = "Locked"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	# Here we will find a way to transition from LOCKED to another state like IDLE
	pass
