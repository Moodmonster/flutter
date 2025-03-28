import 'package:flutter/material.dart';
import 'package:moodmonster/config/routes/app_router.dart';

class DataNullScreen extends StatelessWidget {
  const DataNullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline),
          Text(
            "데이터가 없습니다",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              decoration: TextDecoration.none,
            ),
          ),
          TextButton(
            onPressed: () {
              AppRouter.pop();
            },
            child: Text("뒤로가기"),
          ),
        ],
      ),
    );
  }
}
