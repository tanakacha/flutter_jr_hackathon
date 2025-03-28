import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('確認画面'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Gap(80),
          Text(
            '体を起こしましたか？',
            style: TextStyle(fontSize: 30),
          ),
          Gap(150),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Gap(10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
                child: Text(
                  'はい',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                onPressed: () {
                  context.go('/game');
                },
              ),
              Gap(0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: Colors.blueAccent[100],
                ),
                child: Text(
                  'いいえ',
                  style: TextStyle(
                    color: Colors.black,
                    // color: Colors.blue,
                    fontSize: 30,
                  ),
                ),
                onPressed: () {},
              ),
              Gap(0),
            ],
          ),
        ],
      ),
    );
  }
}
