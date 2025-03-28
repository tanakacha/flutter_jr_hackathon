import 'package:flutter/material.dart';
import 'package:flutter_jr_hackathon/scenes/timer/timer_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:three_js_geometry/icosahedron.dart';
import 'package:three_js/three_js.dart' as three;
import 'package:three_js_objects/three_js_objects.dart';

class SphereData {
  SphereData(
      {required this.mesh, required this.collider, required this.velocity});

  three.Mesh mesh;
  three.BoundingSphere collider;
  three.Vector3 velocity;
}

class ThreeDGameWidget extends StatefulWidget {
  const ThreeDGameWidget({super.key});

  @override
  _ThreeDGameWidgetState createState() => _ThreeDGameWidgetState();
}

class _ThreeDGameWidgetState extends State<ThreeDGameWidget> {
  List<int> data = List.filled(60, 0, growable: true);
  late Timer timer;
  late three.ThreeJS threeJs;

  //以下玉関係
  List<SphereData> spheres = [];
  int sphereIdx = 0;
  three.Vector3 playerDirection = three.Vector3();

  Octree worldOctree = Octree();
  Capsule playerCollider =
      Capsule(three.Vector3(0, 0.35, 0), three.Vector3(0, 1, 0), 0.35);
  bool playerOnFloor = true;
  three.Vector3 playerVelocity = three.Vector3();
  int mouseTime = 0;
  double gravity = 30;

  three.Vector3 vector1 = three.Vector3();
  three.Vector3 vector2 = three.Vector3();
  three.Vector3 vector3 = three.Vector3();

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        data.removeAt(0);
        data.add(threeJs.clock.fps);
      });
    });
    threeJs = three.ThreeJS(
      onSetupComplete: () {
        setState(() {});
      },
      setup: setup,
    );
    super.initState();

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        yaw += event.y * 0.1; // Y軸の回転データを使用
        pitch += event.x * 0.1; // X軸の回転データを使用

        // カメラの回転を更新
        updateCameraRotation();
      });
    });
  }

  @override
  void dispose() {
    controls.dispose();
    timer.cancel();
    threeJs.dispose();
    three.loading.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        threeJs.build(),
        ElevatedButton(
          child: const Text("発射"),
          onPressed: () {
            throwBall();
          },
        ),
      ],
    ));
  }

  final velocity = three.Vector3.zero();
  final direction = three.Vector3.zero();
  final vertex = three.Vector3.zero();
  final color = three.Color();

  // ジャイロスコープのデータを保持
  double yaw = 0.0; // 水平方向の回転
  double pitch = 0.0; // 垂直方向の回転

  late three.PointerLockControls controls;
  late three.Raycaster raycaster;

  List<three.Mesh> objects = [];

  int prevTime = DateTime.now().microsecondsSinceEpoch;

  void updateCameraRotation() {
    // カメラの回転をジャイロスコープデータに基づいて更新
    threeJs.camera.rotation.set(pitch, yaw, 0);
  }

  Future<void> setup() async {
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

    final floorMaterial =
        three.MeshBasicMaterial.fromMap({'vertexColors': true});

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

  double number(bool val) {
    return val ? 1.0 : 0.0;
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

  void playerCollisions() {
    OctreeData? result = worldOctree.capsuleIntersect(playerCollider);
    playerOnFloor = false;
    if (result != null) {
      playerOnFloor = result.normal.y > 0;
      if (!playerOnFloor) {
        playerVelocity.addScaled(
            result.normal, -result.normal.dot(playerVelocity));
      }
      if (result.depth > 0.02) {
        playerCollider.translate(result.normal.scale(result.depth));
      }
    }
  }

  void spheresCollisions() {
    for (int i = 0, length = spheres.length; i < length; i++) {
      SphereData s1 = spheres[i];
      for (int j = i + 1; j < length; j++) {
        SphereData s2 = spheres[j];
        num d2 = s1.collider.center.distanceToSquared(s2.collider.center);
        double r = s1.collider.radius + s2.collider.radius;
        double r2 = r * r;

        if (d2 < r2) {
          three.Vector3 normal =
              vector1.sub2(s1.collider.center, s2.collider.center).normalize();
          three.Vector3 v1 =
              vector2.setFrom(normal).scale(normal.dot(s1.velocity));
          three.Vector3 v2 =
              vector3.setFrom(normal).scale(normal.dot(s2.velocity));

          s1.velocity.add(v2).sub(v1);
          s2.velocity.add(v1).sub(v2);

          double d = (r - math.sqrt(d2)) / 2;

          s1.collider.center.addScaled(normal, d);
          s2.collider.center.addScaled(normal, -d);
        }
      }
    }
  }

  void throwBall() {
    print("throwBall");
    double sphereRadius = 10;
    IcosahedronGeometry sphereGeometry = IcosahedronGeometry(sphereRadius, 5);
    print("Geometry created: $sphereGeometry");
    three.MeshLambertMaterial sphereMaterial =
        three.MeshLambertMaterial.fromMap({'color': 0xbbbb44});

    final three.Mesh newsphere = three.Mesh(sphereGeometry, sphereMaterial);
    newsphere.castShadow = true;
    newsphere.receiveShadow = true;

    threeJs.scene.add(newsphere);
    print("Sphere added to scene");

    spheres.add(SphereData(
        mesh: newsphere,
        collider: three.BoundingSphere(three.Vector3(0, -100, 0), sphereRadius),
        velocity: three.Vector3()));
    SphereData sphere = spheres.last;
    threeJs.camera.getWorldDirection(playerDirection);
    print("Camera direction: $playerDirection");
    print("Player collider end: ${playerCollider.end}");
    sphere.collider.center
        .setFrom(playerCollider.end)
        .addScaled(playerDirection, playerCollider.radius * 1.5);
    // throw the ball with more force if we hold the button longer, and if we move forward
    double impulse = 5 +
        10 *
            (1 -
                math.exp((mouseTime - DateTime.now().millisecondsSinceEpoch) *
                    0.001));
    sphere.velocity.setFrom(playerDirection).scale(impulse);
    sphere.velocity.addScaled(playerVelocity, 2);
    sphereIdx = (sphereIdx + 1) % spheres.length;
    print("Sphere velocity: ${sphere.velocity}");
    print("Sphere position: ${sphere.collider.center}");
  }

  void updateSpheres(double deltaTime) {
    for (final sphere in spheres) {
      sphere.collider.center.addScaled(sphere.velocity, deltaTime);
      OctreeData? result = worldOctree.sphereIntersect(sphere.collider);
      if (result != null) {
        sphere.velocity.addScaled(
            result.normal, -result.normal.dot(sphere.velocity) * 1.5);
        sphere.collider.center.add(result.normal.scale(result.depth));
      } else {
        sphere.velocity.y -= gravity * deltaTime;
      }

      double damping = math.exp(-1.5 * deltaTime) - 1;
      sphere.velocity.addScaled(sphere.velocity, damping);

      // playerSphereCollision(sphere);
    }

    spheresCollisions();

    for (SphereData sphere in spheres) {
      sphere.mesh.position.setFrom(sphere.collider.center);
    }
  }
}
