import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:three_js/three_js.dart' as three;
import 'package:three_js_geometry/three_js_geometry.dart';
import 'package:three_js_objects/three_js_objects.dart';

class SphereData {
  SphereData(
      {required this.mesh, required this.collider, required this.velocity});

  three.Mesh mesh;
  three.BoundingSphere collider;
  three.Vector3 velocity;
}

class FPSGameTest extends StatefulWidget {
  const FPSGameTest({
    super.key,
  });

  @override
  _FPSGamePageState createState() => _FPSGamePageState();
}

class _FPSGamePageState extends State<FPSGameTest> {
  List<int> data = List.filled(60, 0, growable: true);
  late Timer timer;
  late three.ThreeJS threeJs;
  final vertex = three.Vector3.zero();
  final color = three.Color();
  List<three.Mesh> boxes = [];
  List<three.Object3D> targets = [];

  late double radius;

  // ジャイロスコープのデータを保持
  double yaw = 0.0; // 水平方向の回転
  double pitch = 0.0; // 垂直方向の回転

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
          // Keybindings
          // Add force on keydown
          threeJs.domElement.addEventListener(three.PeripheralType.pointerdown,
              (event) {
            mouseTime = DateTime.now().millisecondsSinceEpoch;
          });
          threeJs.domElement.addEventListener(three.PeripheralType.pointerup,
              (event) {
            throwBall();
          });
          threeJs.domElement.addEventListener(three.PeripheralType.pointerHover,
              (event) {
            threeJs.camera.rotation.y -=
                (event as three.WebPointerEvent).movementX / 100;
            threeJs.camera.rotation.x -= event.movementY / 100;
          });
        },
        setup: setup);
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
    timer.cancel();
    threeJs.dispose();
    three.loading.clear();
    super.dispose();
  }

  void updateCameraRotation() {
    // カメラの回転をジャイロスコープデータに基づいて更新
    threeJs.camera.rotation.set(pitch, yaw, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [threeJs.build()],
    ));
  }

  int stepsPerFrame = 5;
  double gravity = 30;

  List<SphereData> spheres = [];
  int sphereIdx = 0;

  Octree worldOctree = Octree();
  Capsule playerCollider =
      Capsule(three.Vector3(0, 0.35, 0), three.Vector3(0, 1, 0), 0.35);

  three.Vector3 playerVelocity = three.Vector3();
  three.Vector3 playerDirection = three.Vector3();

  bool playerOnFloor = false;
  int mouseTime = 0;
  Map<LogicalKeyboardKey, bool> keyStates = {
    LogicalKeyboardKey.arrowUp: false,
    LogicalKeyboardKey.arrowLeft: false,
    LogicalKeyboardKey.arrowDown: false,
    LogicalKeyboardKey.arrowRight: false,
    LogicalKeyboardKey.space: false,
  };

  three.Vector3 vector1 = three.Vector3();
  three.Vector3 vector2 = three.Vector3();
  three.Vector3 vector3 = three.Vector3();

  Future<void> setup() async {
    threeJs.scene = three.Scene();
    threeJs.scene.background = three.Color.fromHex32(0xffffff); // 背景を白に変更
    threeJs.scene.fog = three.Fog(0xffffff, 0, 750); // フォグを追加

    threeJs.camera =
        three.PerspectiveCamera(70, threeJs.width / threeJs.height, 0.1, 1000);

    threeJs.camera.position.y = 10;
    threeJs.camera.rotation.order = three.RotationOrders.yxz;

    // ライト設定
    final light = three.HemisphereLight(0xeeeeff, 0x777788, 0.8);
    light.position.setValues(0.5, 1, 0.75);
    threeJs.scene.add(light);

    // 床の設定
    three.BufferGeometry floorGeometry =
        three.PlaneGeometry(2000, 2000, 100, 100);
    floorGeometry.rotateX(-math.pi / 2);

    dynamic position = floorGeometry.attributes['position'];
    for (int i = 0, l = position.count; i < l; i++) {
      vertex.fromBuffer(position, i);
      vertex.x += math.Random().nextDouble() * 20 - 10;
      vertex.y += math.Random().nextDouble() * 2;
      vertex.z += math.Random().nextDouble() * 20 - 10;
      position.setXYZ(i, vertex.x, vertex.y, vertex.z);
    }

    floorGeometry = floorGeometry.toNonIndexed();
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

    // ボックスの設定
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

    for (int i = 0; i < 400; i++) {
      final boxMaterial = three.MeshPhongMaterial.fromMap(
          {'specular': 0xffffff, 'flatShading': true, 'vertexColors': true});
      boxMaterial.color.setHSL(math.Random().nextDouble() * 0.2 + 0.5, 0.75,
          math.Random().nextDouble() * 0.25 + 0.75, three.ColorSpace.srgb);

      final box = three.Mesh(boxGeometry, boxMaterial);
      box.position.x = (math.Random().nextDouble() * 20 - 10).floor() * 20 + 40;
      box.position.y = (math.Random().nextDouble() * 20).floor() * 20 + 40;
      box.position.z = (math.Random().nextDouble() * 20 - 10).floor() * 20;

      threeJs.scene.add(box);
      boxes.add(box);
    }

    await loadTargetModel();

    threeJs.addAnimationEvent((dt) {
      double deltaTime = math.min(0.05, dt) / stepsPerFrame;
      if (deltaTime != 0) {
        for (int i = 0; i < stepsPerFrame; i++) {
          controls(deltaTime);
          updateSpheres(deltaTime);
          teleportPlayerIfOob();
        }
      }
    });
  }

  Future<void> loadTargetModel() async {
    final loader = three.OBJLoader(); // モデルのパスを設定

    try {
      // モデルを非同期でロード
      final obj = (await loader
          .fromAsset('assets/models/target.obj'))!; // 修正: `gltf`ではなく`obj`

      // カメラの前方方向を取得
      three.Vector3 forwardVector = getForwardVector();

      // 的の位置を設定（カメラの前方5ユニットに配置）
      three.Vector3 targetPosition = three.Vector3()
        ..setFrom(threeJs.camera.position)
        ..addScaled(forwardVector, 5.0); // カメラの前方5ユニット
      obj.position.setFrom(targetPosition);

      // 的の回転をカメラの方向に向ける
      obj.lookAt(threeJs.camera.position);
      obj.scale.setValues(0.01, 0.01, 0.01);
      // 子オブジェクトをトラバースして設定
      obj.traverse((child) {
        if (child is three.Mesh) {
          child.castShadow = true;
          child.receiveShadow = true;
        }
      });

      targets.add(obj);

      // if (obj.geometry != null) {
      //   obj.geometry!.computeBoundingSphere(); // 関数として呼び出し
      //   final boundingSphere = obj.geometry!.boundingSphere;
      //   if (boundingSphere != null) {
      //     double baseRadius = boundingSphere.radius;

      //     // スケールを考慮して半径を計算
      //     radius = boundingSphere.radius * 0.01;
      //     print('Base radius: $baseRadius, Scale: $radius');
      //   } else {
      //     print('Error: boundingSphere is null');
      //   }
      // } else {
      //   print('Error: geometry is null');
      // }
      // 的をシーンに追加
      threeJs.scene.add(obj);
      // 的をオブジェクトリストに追加
    } catch (e) {
      print('Error loading target model: $e');
    }
  }

  void throwBall() {
    double sphereRadius = 2;
    IcosahedronGeometry sphereGeometry = IcosahedronGeometry(sphereRadius, 5);
    three.MeshLambertMaterial sphereMaterial =
        three.MeshLambertMaterial.fromMap({'color': 0xbbbb44});

    final three.Mesh newsphere = three.Mesh(sphereGeometry, sphereMaterial);
    newsphere.castShadow = true;
    newsphere.receiveShadow = true;

    threeJs.scene.add(newsphere);
    spheres.add(SphereData(
        mesh: newsphere,
        collider: three.BoundingSphere(three.Vector3(0, 10, 0), sphereRadius),
        velocity: three.Vector3()));
    SphereData sphere = spheres.last;

    // カメラの向いている方向を取得
    threeJs.camera.getWorldDirection(playerDirection);

    // スフィアの初期位置をカメラの位置から設定
    sphere.collider.center
        .setFrom(threeJs.camera.position)
        .addScaled(playerDirection, 2.0); // カメラの前方にスフィアを配置

    // スフィアをカメラの方向に一定速度で飛ばす
    double fixedSpeed = 50.0; // 固定速度
    sphere.velocity.setFrom(playerDirection).scale(fixedSpeed); // 一定速度で設定
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

  void checkCollisionWithTarget(SphereData sphere, three.Object3D target) {
    // 玉の中心と的の中心を取得
    three.Vector3 sphereCenter = sphere.collider.center;
    three.Vector3 targetCenter = target.position;

    // 玉の半径と的の半径を設定
    double sphereRadius = sphere.collider.radius;

    // 距離を計算
    double distance = sphereCenter.distanceTo(targetCenter);

    // 衝突判定
    if (distance <= sphereRadius + 10) {
      print('Hit! 玉が的に当たりました！');
      handleTargetHit(target); // 衝突時の処理を呼び出し
    }
  }

  void handleTargetHit(three.Object3D target) {
    // 的をシーンから削除
    threeJs.scene.remove(target);

    // 的をtargetsリストから削除
    targets.remove(target);

    // 必要に応じてスコアを加算
    print('スコアを加算しました！');
  }

  void updateSpheres(double deltaTime) {
    for (final sphere in spheres) {
      sphere.collider.center.addScaled(sphere.velocity, deltaTime);
      OctreeData? result = worldOctree.sphereIntersect(sphere.collider);
      if (result != null) {
        sphere.collider.center.add(result.normal.scale(result.depth));
      }
      // 玉と的の当たり判定をチェック
      for (final target in targets) {
        checkCollisionWithTarget(sphere, target);
      }
    }

    spheresCollisions();

    for (SphereData sphere in spheres) {
      sphere.mesh.position.setFrom(sphere.collider.center);
    }
  }

  three.Vector3 getForwardVector() {
    threeJs.camera.getWorldDirection(playerDirection);
    playerDirection.y = 0;
    playerDirection.normalize();
    return playerDirection;
  }

  three.Vector3 getSideVector() {
    threeJs.camera.getWorldDirection(playerDirection);
    playerDirection.y = 0;
    playerDirection.normalize();
    playerDirection.cross(threeJs.camera.up);
    return playerDirection;
  }

  void controls(double deltaTime) {
    // gives a bit of air control
    double speedDelta = deltaTime * (playerOnFloor ? 25 : 8);

    if (keyStates[LogicalKeyboardKey.arrowUp]!) {
      playerVelocity.add(getForwardVector().scale(speedDelta));
    }
    if (keyStates[LogicalKeyboardKey.arrowDown]!) {
      playerVelocity.add(getForwardVector().scale(-speedDelta));
    }
    if (keyStates[LogicalKeyboardKey.arrowLeft]!) {
      playerVelocity.add(getSideVector().scale(-speedDelta));
    }
    if (keyStates[LogicalKeyboardKey.arrowRight]!) {
      playerVelocity.add(getSideVector().scale(speedDelta));
    }
    if (playerOnFloor) {
      if (keyStates[LogicalKeyboardKey.space]!) {
        playerVelocity.y = 15;
      }
    }
  }

  void teleportPlayerIfOob() {
    if (threeJs.camera.position.y <= -25) {
      playerCollider.start.setValues(0, 0.35, 0);
      playerCollider.end.setValues(0, 1, 0);
      playerCollider.radius = 0.35;
      threeJs.camera.position.setFrom(playerCollider.end);
      threeJs.camera.rotation.set(0, 0, 0);
    }
  }
}
