extends PlayerState

var hadBendBow = false
var mouseSide: float

func EnterState():
	Name = "ChargeShot"
	HandleAnimations()

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	Player.ChargeBar.value += 1
	GetMouseSide()
	HandleAnimations()
	HandleShooting()

func HandleShooting():
	if (Player.KeyMouseLeftClickRelease && Player.remainingArrowsInQuiver):
		# Shooting one arrow
		Player.remainingArrowsInQuiver -= 1
		
		var arrow = Player.ArrowScene.instantiate()
		get_parent().add_child(arrow)
		var mousePosition = Player.get_global_mouse_position()
		print("Player position: "+str(Player.position))
		var arrowPlacement = Player.ArrowPlacement.position
		if (mouseSide):
			arrowPlacement.x *= -1 # Faux il faut que la position soit calculée à partir de la position arrow placement par rapport au joueur (peut être aussi simple d'en avoir un de chaque coté)
		print("Arrow placement: "+str(arrowPlacement)+" Mouse position : "+str(Player.global_position)+" And mouse pos - arrow placement: "+ str(Player.global_position + arrowPlacement))
		arrow.launch(mousePosition, Player.global_position)
		arrow.position = arrowPlacement
		Player.ChangeState(States.ReleaseShot)
		Player.ChargeBar.value = 0

func HandleAnimations():
	if (hadBendBow):
		Player.Animator.play("Charged Shot")
	else:
		Player.Animator.play("Charge Shot")
	Player.Sprite.flip_h = mouseSide

func GetMouseSide():
	var mousePosition = Player.get_global_mouse_position()
	var diff : float = mousePosition.x - Player.global_position.x
	mouseSide = diff < 0

func _on_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Charge Shot":
		hadBendBow = true
