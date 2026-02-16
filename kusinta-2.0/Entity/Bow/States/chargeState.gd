extends BowState

var hadBendBow = false
var mouseSide: float
var shotStrength: float
var gravityModifier: float

func EnterState():
	Name = "Charge"
	shotStrength = 7
	gravityModifier = 0
	HandleAnimations()

func ExitState():
	hadBendBow = false

func Draw():
	pass

func Update(delta: float):
	if (gravityModifier < 5):
		gravityModifier += 0.4
	if (shotStrength < 14):
		shotStrength += 0.56
	HandleAnimations()
	HandleShooting()

func HandleShooting():
	if (Bow.KeyMouseLeftClickRelease && Bow.remainingArrowsInQuiver):
		# Shooting one arrow
		Bow.remainingArrowsInQuiver -= 1
		
		var arrow = Bow.ArrowScene.instantiate()
		arrow.Player = Bow.get_parent()
		var mousePosition = Bow.get_global_mouse_position()
		var arrowPlacement = Bow.ArrowPlacement.global_position
		arrow.Launch(mousePosition, arrowPlacement, shotStrength, gravityModifier)
		arrow.position = arrowPlacement
		Bow.ChangeState(BowStates.Release)
		Bow.ArrowList.append(arrow)
		get_parent().add_child(arrow)


func HandleAnimations():
	if (hadBendBow):
		Bow.Animator.play("Charged")
	else:
		Bow.Animator.play("Charge")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Charge":
		hadBendBow = true
