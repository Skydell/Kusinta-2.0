extends PlayerState

const ledgeFinalPositionX = 10
const ledgeFinalPositionY = -14

var ledgeGrabFinalPosition = Vector2.ZERO

func EnterState():
	Name = "LedgeClimb"
	
	# Get Ledge Direction
	if (Player.RCLedgeGrabLeftLower.is_colliding()):
		Player.ledgeDiection == Vector2.LEFT
	elif (Player.RCLedgeGrabRightLower.is_colliding()):
		Player.ledgeDiection == Vector2.RIGHT
	
	ledgeGrabFinalPosition = Vector2(ledgeFinalPositionX * Player.ledgeDiection.x, ledgeFinalPositionY)

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	HandleAnimations()

func HandleAnimations():
	Player.Animator.play("LedgeClimb")
	Player.Sprite.flip_h = (Player.ledgeDiection.x < 0)

func _on_animator_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "LedgeClimb"):
		Player.global_position += ledgeGrabFinalPosition
		Player.ChangeState(States.Idle)
