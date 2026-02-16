extends BowState

func EnterState():
	Name = "Release"

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	HandleAnimations()

func HandleAnimations():
	Bow.Animator.play("Release")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "Release"):
		Bow.ChangeState(BowStates.Idle)
