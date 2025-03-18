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

  ///콘텐츠, 목차 add할 때 사용할 모달창
  ///사용자로부터 값 입력 받을 수 있고 확인을 누르면 Action이 수행, 사용자가 임의로 취소 가능한 알림창
  static void showAlertForAdd({
    required VoidCallback onPressed,
    required String DialogTtitle,
    required String enterMsg,
    required String cancelMsg,
  }) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
    //사용자가 선택한 이미지 저장 변수(앱용)
    File? selectedThumbImg;
    //사용자가 선택한 이미지 저장 변수(웹용)
    Uint8List? selectedThumbImgWeb;

    //사용자가 저장한 이미지의 파일명
    String? thumbImgFileName;
    final ImagePicker picker = ImagePicker();
    showDialog(
      context: AppRouter.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                DialogTtitle,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              contentPadding: const EdgeInsets.all(20.0),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height *
                      0.7, // 화면 높이의 70%로 제한
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  width: 320.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: Text("제목", softWrap: true),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            //width: 170.w,
                            child: TextField(
                              style: TextStyle(fontSize: 14),
                              controller: _titleController,
                              cursorHeight: 16,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                focusedBorder: OutlineInputBorder(
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
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: Text("설명", softWrap: true),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 100.h,
                              //width: 170.w,
                              child: TextField(
                                style: TextStyle(fontSize: 14),
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                controller: _descController,
                                cursorHeight: 16,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: Text("썸네일 이미지", softWrap: true),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            //width: 170.w,
                            child: Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      //모서리를 둥글게
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: AppColors.primary,

                                    alignment: Alignment.centerLeft,
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () async {
                                    final XFile? pickedFile = await picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      if (kIsWeb) {
                                        //웹에서 올리는 거면
                                        final bytes =
                                            await pickedFile.readAsBytes();
                                        setState(() {
                                          selectedThumbImgWeb = bytes;
                                          thumbImgFileName = pickedFile.name;
                                        });
                                      } else {
                                        // 모바일, 데스크탑 용 처리
                                        setState(() {
                                          selectedThumbImg = File(
                                            pickedFile.path,
                                          );
                                        });
                                      }
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          color: AppColors.white,
                                        ),
                                        Text(
                                          "이미지 업로드",
                                          style: TextStyle(
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (selectedThumbImg != null ||
                                    selectedThumbImgWeb != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 60.h,
                                          width: 60.w,

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          child:
                                              selectedThumbImg != null
                                                  ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    child: Image.file(
                                                      selectedThumbImg!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                  : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    child: Image.memory(
                                                      selectedThumbImgWeb!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "파일명",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                thumbImgFileName ?? "",
                                                //softWrap: true,
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      //구분선
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                ),
                                onPressed: () {
                                  if (_titleController.text.isEmpty ||
                                      _descController.text.isEmpty ||
                                      thumbImgFileName == null) {
                                    //입력 안된 값이 있을 경우
                                    showSnackBar(
                                      content: "입력이 안 된 값이 존재합니다",
                                      backgroundColor: AppColors.secondary,
                                      textColor: AppColors.black,
                                    );
                                  } else {
                                    //ContentDumyData.add(Content(code: DateTime.now().hashCode, title: _titleController.text, desc: _descController.text, author: author, userId: userId, contentType: contentType, clickCount: clickCount, thumbnailUrl: thumbnailUrl))
                                    AppRouter.pop();
                                    onPressed();
                                  }
                                },
                                child: Text(
                                  "확인",
                                  style: AppTypography.mainCaption_2,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                ),
                                onPressed: () {
                                  AppRouter.pop();
                                },
                                child: Text(
                                  "취소",
                                  style: AppTypography.mainCaption_2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
