extends BowState

var closerArrowToMouse: ArrowProjectile = null

func EnterState():
	Name = "Recall"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	FindCloserArrowToCursor()
	HightLightCloserArrowToCursor()
	RecallArrow()
	HandleAnimations()

func HandleAnimations():
	Bow.Animator.play("Idle")

func FindCloserArrowToCursor():
	var mousePosition = Bow.get_global_mouse_position()
	var closerToMouse : ArrowProjectile = null
	var minDistance = 1000
	for arrow in Bow.ArrowList:
		var distance = sqrt(pow(mousePosition.x - arrow.position.x, 2) + pow(mousePosition.y - arrow.position.y,2))
		if (distance < minDistance):
			minDistance = distance
			closerToMouse = arrow
	closerArrowToMouse = closerToMouse

func HightLightCloserArrowToCursor():
	for arrow in Bow.ArrowList:
		if (arrow == closerArrowToMouse):
			arrow.HightLightArrow()
		else:
			arrow.RemoveHightLight()

func RecallArrow():
	# TODO fix auto recall + fix bug a recalling with empty list of arrows
	# TODO Fix spawn of arrow on recall to avoid it being in a wall
	if (Bow.KeyMouseRightClickPressed):
		closerArrowToMouse.Recall(Bow.get_parent().global_position, closerArrowToMouse.global_position)
		Bow.ChangeState(BowStates.Idle)
	
