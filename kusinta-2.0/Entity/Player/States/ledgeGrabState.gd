extends PlayerState

# Offset Position of the player with releasing to avoid 
const ledgeReleaseXNudge = 1
const ledgeReleaseYNudge = 5
const ledgeGrabSnapY = 6

var cornerGrabPosition: Vector2 = Vector2.ZERO
var ledgeGrabSnapPosition: Vector2 = Vector2.ZERO

func EnterState():
	Name = "LedgeGrab"
	# get ledge direction
	if (Player.RCLedgeGrabLeftLower.is_colliding()):
		Player.ledgeDiection = Vector2.LEFT
	if (Player.RCLedgeGrabRightLower.is_colliding()):
		Player.ledgeDiection = Vector2.RIGHT
	
	# Snap the player to the corner
	# Use the tilemap to find the corners global position
	var _tileSize = Player.CollisionMap.tile_set.tile_size # return a vector2 of the tileSize
	var _tileSizeCorrection = (_tileSize / 2) as Vector2 # Adjust the center position of the tile (devided by half to get the corner)
	var _collisionPoint # Where raycast if colliding
	var _tileCoords # the coordinate of tiles
	
	if (Player.ledgeDiection == Vector2.LEFT):
		if (Player.RCLedgeGrabLeftLower.is_colliding()):
			_collisionPoint = Player.RCLedgeGrabLeftLower.get_collision_point() # Point where the raycast is colliding
			_tileCoords = Player.CollisionMap.local_to_map(_collisionPoint) # Convert to tilemap coordinates
			cornerGrabPosition = Player.CollisionMap.map_to_local(_tileCoords) - _tileSizeCorrection # Coordinate of the tile with the correction
	if (Player.ledgeDiection == Vector2.RIGHT):
		if (Player.RCLedgeGrabRightLower.is_colliding()):
			_collisionPoint = Player.RCLedgeGrabRightLower.get_collision_point() # Point where the raycast is colliding
			_tileCoords = Player.CollisionMap.local_to_map(_collisionPoint) # Convert to tilemap coordinates
			cornerGrabPosition = Player.CollisionMap.map_to_local(_tileCoords) - _tileSizeCorrection # Coordinate of the tile with the correction
	
	ledgeGrabSnapPosition = Vector2(cornerGrabPosition.x + (Player.ledgeDiection.x * -1), cornerGrabPosition.y + ledgeGrabSnapY)
	Player.global_position = ledgeGrabSnapPosition

func ExitState():
	pass

func Draw():
	pass

func Update(delta: float):
	# Here we will find a way to transition from LOCKED to another state like IDLE
	HandleJumpUp()
	HandleClimbUp()
	HandleLedgeRelease()
	HandleAnimations()
	
func HandleLedgeRelease():
	if (Player.keyDown):
		Player.global_position += Vector2(ledgeReleaseXNudge * Player.ledgeDiection.x * -1, ledgeReleaseYNudge)
		Player.ChangeState(States.Fall)

func HandleJumpUp():
	if (Player.KeyJumpPressed):
		Player.global_position += Vector2(ledgeReleaseXNudge * Player.ledgeDiection.x * -2, ledgeReleaseYNudge)
		Player.ChangeState(States.Jump)

func HandleClimbUp():
	if (Player.KeyUpPressed):
		Player.ChangeState(States.LedgeClimb)
		

func HandleAnimations():
	Player.Animator.play("LedgeGrab")
	Player.Sprite.flip_h = (Player.ledgeDiection.x < 0)
