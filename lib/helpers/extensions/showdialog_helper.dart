import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/dumyData/contentDumyData.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/helpers/constants/app_typography.dart';
import 'package:moodmonster/models/content.model.dart';

@immutable
class ShowDialogHelper {
  const ShowDialogHelper._();

  ///알림창만 띄웁니다.
  static void showAlert({required String title, required String message}) {
    showCupertinoDialog(
      context: AppRouter.navigatorKey.currentContext!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                "확인",
                style: TextStyle(color: AppColors.primary),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  ///확인을 누르면 Action이 수행되는 알림창을 띄웁니다.
  static void showAlertWithAction({
    required VoidCallback onPressed,
    required String title,
    required String message,
  }) {
    showCupertinoDialog(
      context: AppRouter.navigatorKey.currentContext!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                AppRouter.pop();
                onPressed();
              },
              child: const Text(
                "확인",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  ///확인을 누르면 Action이 수행되지만 사용자가 임의로 취소 가능한 알림창을 띄웁니다.
  static void showAlertWithActionAndCancel({
    required VoidCallback onPressed,
    required String title,
    required String message,
    required String enterMsg,
    required String cancelMsg,
  }) {
    showCupertinoDialog(
      context: AppRouter.navigatorKey.currentContext!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                AppRouter.pop();
                onPressed();
              },
              child: Text(
                enterMsg,
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                AppRouter.pop();
              },
              child: Text(
                cancelMsg,
                style: const TextStyle(color: AppColors.lightBlack),
              ),
            ),
          ],
        );
      },
    );
  }

  ///스낵바를 띄웁니다.
  static void showSnackBar({
    required String content,
    Color? backgroundColor,
    Color? textColor,
  }) {
    ScaffoldMessenger.of(AppRouter.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(content, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
      ),
    );
  }

  ///로딩을 띄웁니다.
  static void showLoading() {
    showCupertinoDialog(
      context: AppRouter.navigatorKey.currentContext!,
      builder: (context) {
        return const CupertinoActivityIndicator(
          color: Colors.white,
          radius: 24,
        );
      },
    );
  }

  /// 로딩 모달을 띄웁니다.
  static void showLoadingWithMessage({required String message}) {
    showCupertinoDialog(
      context: AppRouter.navigatorKey.currentContext!,
      barrierDismissible: false, // 바깥 터치로 닫히지 않도록
      builder: (context) {
        return CupertinoAlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const CupertinoActivityIndicator(radius: 14),
              const SizedBox(height: 16),
              Text(message, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  ///로딩을 닫습니다.
  static void closeLoading() {
    AppRouter.pop();
  }
}
