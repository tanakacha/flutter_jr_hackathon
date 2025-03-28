import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;
import 'dart:math' as math;

// 必要な変数を宣言
late three.PointerLockControls controls;
late three.Raycaster raycaster;
final three.Vector3 vertex = three.Vector3();
final List<three.Object3D> objects = [];
final three.Color color = three.Color();
final velocity = three.Vector3.zero();
final direction = three.Vector3.zero();
int prevTime = DateTime.now().microsecondsSinceEpoch;

setup(three.ThreeJS threeJs) async {
  threeJs.camera =
      three.PerspectiveCamera(75, threeJs.width / threeJs.height, 1, 1000);
  threeJs.camera.position.y = 10;

  threeJs.scene = three.Scene();
  threeJs.scene.background = three.Color.fromHex32(0xffffff);
  threeJs.scene.fog = three.Fog(0xffffff, 0, 750);

  final light = three.HemisphereLight(0xeeeeff, 0x777788, 0.8);
  light.position.setValues(0.5, 1, 0.75);
  threeJs.scene.add(light);

  controls = three.PointerLockControls(threeJs.camera, threeJs.globalKey);

  controls.lock();

  threeJs.scene.add(controls.getObject);

  raycaster =
      three.Raycaster(three.Vector3.zero(), three.Vector3(0, -1, 0), 0, 10);

  // floor

  three.BufferGeometry floorGeometry =
      three.PlaneGeometry(2000, 2000, 100, 100);
  floorGeometry.rotateX(-math.pi / 2);

  // vertex displacement

  dynamic position = floorGeometry.attributes['position'];

  for (int i = 0, l = position.count; i < l; i++) {
    vertex.fromBuffer(position, i);

    vertex.x += math.Random().nextDouble() * 20 - 10;
    vertex.y += math.Random().nextDouble() * 2;
    vertex.z += math.Random().nextDouble() * 20 - 10;

    position.setXYZ(i, vertex.x, vertex.y, vertex.z);
  }

  floorGeometry =
      floorGeometry.toNonIndexed(); // ensure each face has unique vertices

  position = floorGeometry.attributes['position'];
  final List<double> colorsFloor = [];

  for (int i = 0, l = position.count; i < l; i++) {
    color.setHSL(math.Random().nextDouble() * 0.3 + 0.5, 0.75,
        math.Random().nextDouble() * 0.25 + 0.75, three.ColorSpace.srgb);
    colorsFloor.addAll([color.red, color.green, color.blue]);
  }

  floorGeometry.setAttributeFromString(
      'color', three.Float32BufferAttribute.fromList(colorsFloor, 3));

  final floorMaterial = three.MeshBasicMaterial.fromMap({'vertexColors': true});

  final floor = three.Mesh(floorGeometry, floorMaterial);
  threeJs.scene.add(floor);

  final boxGeometry = three.BoxGeometry(20, 20, 20).toNonIndexed();

  position = boxGeometry.attributes['position'];
  final List<double> colorsBox = [];

  for (int i = 0, l = position.count; i < l; i++) {
    color.setHSL(math.Random().nextDouble() * 0.3 + 0.5, 0.75,
        math.Random().nextDouble() * 0.25 + 0.75, three.ColorSpace.srgb);
    colorsBox.addAll([color.red, color.green, color.blue]);
  }

  boxGeometry.setAttributeFromString(
      'color', three.Float32BufferAttribute.fromList(colorsBox, 3));

  for (int i = 0; i < 500; i++) {
    final boxMaterial = three.MeshPhongMaterial.fromMap(
        {'specular': 0xffffff, 'flatShading': true, 'vertexColors': true});
    boxMaterial.color.setHSL(math.Random().nextDouble() * 0.2 + 0.5, 0.75,
        math.Random().nextDouble() * 0.25 + 0.75, three.ColorSpace.srgb);

    final box = three.Mesh(boxGeometry, boxMaterial);
    box.position.x = (math.Random().nextDouble() * 20 - 10).floor() * 20;
    box.position.y = (math.Random().nextDouble() * 20).floor() * 20 + 40;
    box.position.z = (math.Random().nextDouble() * 20 - 10).floor() * 20;

    threeJs.scene.add(box);
    objects.add(box);
  }

  threeJs.addAnimationEvent((dt) {
    animate(dt);
  });
}

void animate(double dt) {
  int time = DateTime.now().microsecondsSinceEpoch;
  if (controls.isLocked == true) {
    raycaster.ray.origin.setFrom(controls.getObject.position);
    raycaster.ray.origin.y -= 10;

    final intersections = raycaster.intersectObjects(objects, false);
    final onObject = intersections.isNotEmpty;
    final delta = (time - prevTime) / 1000000;

    velocity.x -= velocity.x * 10.0 * delta;
    velocity.z -= velocity.z * 10.0 * delta;

    velocity.y -= 9.8 * 100.0 * delta; // 100.0 = mass

    direction
        .normalize(); // this ensures consistent movements in all directions

    controls.moveRight(-velocity.x * delta);
    controls.moveForward(-velocity.z * delta);
    controls.getObject.position.y += (velocity.y * delta); // new behavior

    if (controls.getObject.position.y < 10) {
      velocity.y = 0;
      controls.getObject.position.y = 10;

      // canJump = true;
    }
  }
  prevTime = time;
}
