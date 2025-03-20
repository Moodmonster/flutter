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

  ///사용자로부터 값 입력 받을 수 있고 확인을 누르면 Action이 수행, 사용자가 임의로 취소 가능한 알림창
  static void showAlertWithTextFieldAndActionAndCancel({
    required VoidCallback onPressed,
    required String title,
    required String message,
    required String enterMsg,
    required String cancelMsg,
  }) {
    TextEditingController _SongMoodEnterController = TextEditingController();
    showCupertinoDialog(
      context: AppRouter.navigatorKey.currentContext!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              SizedBox(height: 4.h),
              Text(
                message,
                style: TextStyle(fontSize: 12, color: AppColors.lightBlack),
              ),
              SizedBox(height: 10.h),
              Material(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 300.w,
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    controller: _SongMoodEnterController,
                    cursorHeight: 14,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "ex:재즈풍의 피아노",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightBlack,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  ///로딩을 닫습니다.
  static void closeLoading() {
    AppRouter.pop();
  }
}
