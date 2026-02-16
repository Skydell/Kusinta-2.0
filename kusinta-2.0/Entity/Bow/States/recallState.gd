extends BowState

var closerArrowToMouse: ArrowProjectile = null

func EnterState():
	Name = "Recall"
	var mousePosition = Bow.get_global_mouse_position()
	var closerToMouse : ArrowProjectile = null
	var minDistance = 1000
	for arrow in Bow.ArrowList:
		var distance = sqrt(pow(mousePosition.x - arrow.position.x, 2) + pow(mousePosition.y - arrow.position.y,2))
		if (distance < minDistance):
			minDistance = distance
			closerToMouse = arrow
	closerArrowToMouse = closerToMouse
	closerArrowToMouse.Recall(Bow.get_parent().global_position, closerArrowToMouse.global_position)

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	HandleAnimations()

func HandleAnimations():
	Bow.Animator.play("Idle")
