import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodmonster/common/mood_fonts.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/helpers/constants/app_typography.dart';
import 'package:moodmonster/helpers/extensions/showdialog_helper.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/pages/content_screen.page_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // 탭 컨트롤러
  late TabController _tabController;
  //선택된 탭의 content탭 종류(웹툰 or 소설)저장
  ValueNotifier<MyContentType> selectedTabContentType =
      ValueNotifier<MyContentType>(MyContentType.values[0]);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 탭 변경 감지
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        selectedTabContentType.value =
            MyContentType.values[_tabController.index];
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: AppColors.background,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      height: 50,
                      child: TabBar(
                        controller: _tabController,
                        tabs: [Tab(text: "WEBTOON"), Tab(text: "NOVEL")],
                        labelStyle: MoodFonts.titleStyleWhite,
                        padding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicatorSize: TabBarIndicatorSize.label,
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: WidgetStateProperty.all<Color>(
                          Colors.transparent,
                        ),

                        indicator: BoxDecoration(),
                        dividerColor: Colors.transparent,
                        labelColor: AppColors.mainTextColor,
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        IconButton(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.mainTextColor,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: AppColors.mainTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: ContentScreen(contentType: MyContentType.Webtoon),
                    ),
                    SingleChildScrollView(
                      child: ContentScreen(contentType: MyContentType.Novel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ValueListenableBuilder<MyContentType>(
          valueListenable: selectedTabContentType,
          builder: (context, tabContentType, child) {
            return FloatingActionButton(
              onPressed: () {
                showAlertForAdd(
                  onPressed: () {},
                  DialogTtitle: "콘텐츠 추가",
                  enterMsg: "확인",
                  cancelMsg: "취소",
                  selectedTabContentType: tabContentType,
                );
              },
              child: Icon(Icons.add, color: AppColors.background),
              elevation: 10,
              backgroundColor: AppColors.mainTextColor,
              shape: CircleBorder(),
            );
          },
        ),
      ),
    );
  }
}

///콘텐츠, 목차 add할 때 사용할 모달창
///사용자로부터 값 입력 받을 수 있고 확인을 누르면 Action이 수행, 사용자가 임의로 취소 가능한 알림창
void showAlertForAdd({
  required VoidCallback onPressed,
  required String DialogTtitle,
  required String enterMsg,
  required String cancelMsg,
  required MyContentType selectedTabContentType,
}) {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _AIPromptController = TextEditingController();
  //사용자가 선택한 이미지 저장 변수(앱용)
  File? selectedThumbImg;
  //사용자가 선택한 이미지 저장 변수(웹용)
  Uint8List? selectedThumbImgWeb;

  //사용자가 저장한 이미지의 파일명
  String? thumbImgFileName;
  final ImagePicker picker = ImagePicker();
  showDialog(
    barrierColor: Colors.transparent,
    context: AppRouter.navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              DialogTtitle,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.dialogBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            contentPadding: const EdgeInsets.all(20.0),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height * 0.7, // 화면 높이의 70%로 제한
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
                              hoverColor: Colors.transparent,
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
                                hoverColor: Colors.transparent,
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
                          child:
                              //소설에서 +버튼 눌렀으면 파일 업로드 말고 AI자동생성 프롬프트 입력란
                              selectedTabContentType == MyContentType.Novel
                                  ? Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("✨ AI 자동 생성"),
                                            Text(
                                              "원하는 이미지 분위기를 입력하세요",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: AppColors.lightBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Container(
                                        height: 50.h,
                                        child: TextField(
                                          style: TextStyle(fontSize: 14),
                                          maxLines: null,
                                          expands: true,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          controller: _AIPromptController,
                                          cursorHeight: 16,
                                          decoration: InputDecoration(
                                            hoverColor: Colors.transparent,
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            //모서리를 둥글게
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          backgroundColor: AppColors.primary,

                                          alignment: Alignment.centerLeft,
                                          textStyle: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        onPressed: () async {
                                          final XFile? pickedFile = await picker
                                              .pickImage(
                                                source: ImageSource.gallery,
                                              );
                                          if (pickedFile != null) {
                                            if (kIsWeb) {
                                              //웹에서 올리는 거면
                                              final bytes =
                                                  await pickedFile
                                                      .readAsBytes();
                                              setState(() {
                                                selectedThumbImgWeb = bytes;
                                                thumbImgFileName =
                                                    pickedFile.name;
                                              });
                                            } else {
                                              // 모바일, 데스크탑 용 처리
                                              setState(() {
                                                selectedThumbImg = File(
                                                  pickedFile.path,
                                                );

                                                thumbImgFileName =
                                                    pickedFile.name;
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      thumbImgFileName ?? "",
                                                      //softWrap: true,
                                                      style: TextStyle(
                                                        fontSize: 10,
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
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                overlayColor: Colors.transparent,
                              ),
                              onPressed: () {
                                if (_titleController.text.isEmpty ||
                                    _descController.text.isEmpty ||
                                    thumbImgFileName == null) {
                                  //입력 안된 값이 있을 경우
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "압력 안 된 값이 있습니다",
                                        style: TextStyle(
                                          color: AppColors.black,
                                        ),
                                      ),
                                      backgroundColor: AppColors.secondary,
                                    ),
                                  );
                                } else {
                                  //ContentDumyData.add(Content(code: DateTime.now().hashCode, title: _titleController.text, desc: _descController.text, author: author, userId: userId, contentType: contentType, clickCount: clickCount, thumbnailUrl: thumbnailUrl))
                                  AppRouter.pop();
                                  onPressed();
                                }
                              },
                              child: Text(
                                "확인",
                                style: AppTypography.mainCaption_1.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                overlayColor: Colors.transparent,
                              ),
                              onPressed: () {
                                AppRouter.pop();
                              },
                              child: Text(
                                "취소",
                                style: AppTypography.mainCaption_1,
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
