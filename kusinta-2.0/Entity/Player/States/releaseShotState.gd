extends PlayerState

func EnterState():
	Name = "ReleaseShot"

func Update(delta: float):
	HandleAnimations()

func _on_animator_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "Release Shot"):
		Player.ChangeState(States.Idle)

func HandleAnimations():
	Player.Animator.play("Release Shot")
	Player.HandleFlipH()
