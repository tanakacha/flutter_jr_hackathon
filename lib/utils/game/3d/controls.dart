import 'package:three_js/three_js.dart' as three;

three.Vector3 getForwardVector(three.PerspectiveCamera camera) {
  three.Vector3 direction = three.Vector3();
  camera.getWorldDirection(direction);
  direction.y = 0;
  direction.normalize();
  return direction;
}

three.Vector3 getSideVector(three.PerspectiveCamera camera) {
  three.Vector3 direction = three.Vector3();
  camera.getWorldDirection(direction);
  direction.y = 0;
  direction.normalize();
  direction.cross(camera.up);
  return direction;
}

void controls(
    double deltaTime,
    Map<LogicalKeyboardKey, bool> keyStates,
    three.Vector3 playerVelocity,
    bool playerOnFloor,
    three.PerspectiveCamera camera) {
  double speedDelta = deltaTime * (playerOnFloor ? 25 : 8);

  if (keyStates[LogicalKeyboardKey.arrowUp]!) {
    playerVelocity.add(getForwardVector(camera).scale(speedDelta));
  }
  if (keyStates[LogicalKeyboardKey.arrowDown]!) {
    playerVelocity.add(getForwardVector(camera).scale(-speedDelta));
  }
  if (keyStates[LogicalKeyboardKey.arrowLeft]!) {
    playerVelocity.add(getSideVector(camera).scale(-speedDelta));
  }
  if (keyStates[LogicalKeyboardKey.arrowRight]!) {
    playerVelocity.add(getSideVector(camera).scale(speedDelta));
  }
  if (playerOnFloor && keyStates[LogicalKeyboardKey.space]!) {
    playerVelocity.y = 15;
  }
}
