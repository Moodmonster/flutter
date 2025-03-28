import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/core/local/local_storage_base.dart';
import 'package:moodmonster/core/local/local_storage_keys.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/helpers/constants/app_typography.dart';
import 'package:moodmonster/helpers/extensions/showdialog_helper.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/pages/content_screen.page_view.dart';
import 'package:moodmonster/providers/novel_provider.dart';
import 'package:moodmonster/providers/webtoon_provider.dart';

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
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: AppColors.background,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 220.w,
                        height: 60.h,
                        child: TabBar(
                          unselectedLabelColor: AppColors.deActiveGray,
                          controller: _tabController,
                          tabs: [Tab(text: "WEBTOON"), Tab(text: "NOVEL")],
                          labelStyle: AppTypography.body.copyWith(
                            color: AppColors.mainTextColor,
                          ),
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
                        child: ContentScreen(
                          contentType: MyContentType.Webtoon,
                        ),
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
        ),
        floatingActionButton: ValueListenableBuilder<MyContentType>(
          valueListenable: selectedTabContentType,
          builder: (context, tabContentType, child) {
            return FloatingActionButton(
              onPressed: () {
                showAlertForAdd(
                  DialogTtitle: "Add Content",
                  enterMsg: "Confirm",
                  cancelMsg: "Cancel",
                  selectedTabContentType: tabContentType,
                );
              },
              child: Icon(Icons.add, color: AppColors.background),
              elevation: 10,
              backgroundColor: AppColors.primary,
              shape: CircleBorder(),
            );
          },
        ),
      ),
    );
  }
}

///콘텐츠, 목차 add할 때 사용할 모달창
///사용자로부터 값 입력 받을 수 있고 Confirm을 누르면 Action이 수행, 사용자가 임의로 Cancel 가능한 알림창
void showAlertForAdd({
  required String DialogTtitle,
  required String enterMsg,
  required String cancelMsg,
  required MyContentType selectedTabContentType,
}) {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _AIPromptController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  //사용자가 선택한 이미지 저장 변수(앱용)
  File? selectedThumbImg;
  //사용자가 선택한 이미지 저장 변수(웹용)
  Uint8List? selectedThumbImgWeb;

  //사용자가 저장한 이미지의 File Name
  String? thumbImgFileName;
  final ImagePicker picker = ImagePicker();

  //snack바를 다이얼로그 창 위에 띄우기 위해
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  showDialog(
    //barrierColor: Colors.transparent,
    context: AppRouter.navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return ScaffoldMessenger(
            key: _scaffoldMessengerKey,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: AlertDialog(
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
                        MediaQuery.of(context).size.height *
                        0.7, // 다이어로그 높이를 화면 높이의 70%로 제한
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    width: 320.w,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Title", softWrap: true),
                              SizedBox(height: 5.h),
                              Flexible(
                                //width: 170.w,
                                child: TextField(
                                  style: TextStyle(fontSize: 14),
                                  controller: _titleController,
                                  cursorHeight: 16,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hoverColor: Colors.transparent,
                                    filled: true,
                                    fillColor: AppColors.dialogTextField,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Author", softWrap: true),
                              SizedBox(height: 5.h),
                              Flexible(
                                //width: 170.w,
                                child: TextField(
                                  style: TextStyle(fontSize: 14),
                                  controller: _authorController,
                                  cursorHeight: 16,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hoverColor: Colors.transparent,
                                    filled: true,
                                    fillColor: AppColors.dialogTextField,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Description", softWrap: true),
                              SizedBox(height: 5.h),
                              Flexible(
                                child: SizedBox(
                                  height: 80.h,
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
                                      fillColor: AppColors.dialogTextField,
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
                      
                          //소설에서 +버튼 눌렀으면 파일 업로드 말고 AI자동생성 프롬프트 입력란
                          selectedTabContentType == MyContentType.Webtoon
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Thumbnail", softWrap: true),
                                  SizedBox(height: 5.h),
                                  Flexible(
                                    //width: 170.w,
                                    child: Column(
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
                                                  "Upload Image",
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
                                                        "File Name",
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
                              )
                              : Container(
                                //썸네일 AI자동 생성 입력시 프롬프트 창
                                margin: EdgeInsets.only(top: 6),
                                padding: EdgeInsets.all(8),
                      
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 222, 222, 222),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("✨ Generate Thumbnail with AI"),
                                          Text(
                                            "Enter image mood or style",
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
                                        textAlignVertical: TextAlignVertical.top,
                                        controller: _AIPromptController,
                                        cursorHeight: 16,
                                        decoration: InputDecoration(
                                          hoverColor: Colors.transparent,
                                          filled: true,
                                          fillColor: AppColors.dialogTextField,
                                          border: InputBorder.none,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
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
                              ),
                      
                          SizedBox(height: 5.h),
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
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      overlayColor: Colors.transparent,
                                    ),
                                    onPressed: () async {
                                      //입력 안된 값이 있을 경우
                                      if (_titleController.text.isEmpty ||
                                          _descController.text.isEmpty ||
                                          _authorController.text.isEmpty ||
                                          (selectedTabContentType == //웹툰 추가이면서 이미지 첨부 안했으면
                                                  MyContentType.Webtoon &&
                                              thumbImgFileName == null)) {
                                        _scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Some fields are missing",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.mainTextColor,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColors.secondary,
                                              ),
                                            );
                                      } else {
                                        //소설 추가하기 이면
                                        if (selectedTabContentType ==
                                            MyContentType.Novel) {
                                          final novelNotifier =
                                              ProviderScope.containerOf(
                                                context,
                                                listen: false,
                                              ).read(NovelProvider.notifier);
                      
                                          //로딩창 띄우기
                                          ShowDialogHelper.showLoadingWithMessage(
                                            message: "Adding content....",
                                          );
                      
                                          try {
                                            await novelNotifier.addNovel(
                                              title: _titleController.text,
                                              desc: _descController.text,
                                              author: _authorController.text,
                                              userId: prefs.getIdToken() ?? "e",
                                              prompt: _AIPromptController.text,
                                            );
                                            ShowDialogHelper.closeLoading();
                                            AppRouter.pop();
                                            ShowDialogHelper.showSnackBar(
                                              content:
                                                  "Content added successfully!",
                                              backgroundColor: AppColors.primary,
                                              durationSeconds: 6,
                                              textColor: AppColors.white,
                                            );
                                          } catch (err) {
                                            ShowDialogHelper.closeLoading();
                                            print(err);
                                            _scaffoldMessengerKey.currentState
                                                ?.showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "An error occurred.",
                                                    ),
                                                  ),
                                                );
                                          }
                                        } else {
                                          //웹툰 추가하기면
                      
                                          final webtoonNotifier =
                                              ProviderScope.containerOf(
                                                context,
                                                listen: false,
                                              ).read(WebtoonProvider.notifier);
                                          //로딩창 띄우기
                                          ShowDialogHelper.showLoadingWithMessage(
                                            message: "Adding content....",
                                          );
                                          try {
                                            if (selectedThumbImg != null) {
                                              //이미지가 모바일에서 업로드한 데이터면
                                              await webtoonNotifier
                                                  .addWebtoonInMobile(
                                                    title: _titleController.text,
                                                    desc: _descController.text,
                                                    author:
                                                        _authorController.text,
                                                    userId: prefs.getIdToken() ?? "e",
                                                    fileData: selectedThumbImg!,
                                                  );
                                            } //  이미지가 웹에서 업로드한 데이터이고 File Name도 제대로 인식했으면
                                            else if (selectedThumbImgWeb !=
                                                    null &&
                                                thumbImgFileName != null) {
                                              await webtoonNotifier
                                                  .addWebtoonInWeb(
                                                    title: _titleController.text,
                                                    desc: _descController.text,
                                                    author:
                                                        _authorController.text,
                                                    userId: prefs.getIdToken() ?? "e",
                                                    fileDataInWeb:
                                                        selectedThumbImgWeb!,
                                                    fileDataNameInWeb:
                                                        thumbImgFileName!,
                                                  );
                                            } else {
                                              _scaffoldMessengerKey.currentState
                                                  ?.showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "There was a problem selecting the image.",
                                                      ),
                                                    ),
                                                  );
                      
                                              return;
                                            }
                                            ShowDialogHelper.closeLoading();
                                            AppRouter.pop();
                                            ShowDialogHelper.showSnackBar(
                                              content:
                                                  "Content added successfully!",
                                              backgroundColor: AppColors.primary,
                                              durationSeconds: 6,
                                              textColor: AppColors.white,
                                            );
                                          } catch (err) {
                                            //오류 발생시 스낵바 띄움
                                            ShowDialogHelper.closeLoading();
                                            print(err);
                                            _scaffoldMessengerKey.currentState
                                                ?.showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "An error occurred.",
                                                    ),
                                                  ),
                                                );
                                          }
                                        }
                      
                                        //onPressed();
                                      }
                                    },
                                    child: Text(
                                      "Confirm",
                                      style: AppTypography.mainCaption_1.copyWith(
                                        color: AppColors.mainTextColor,
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
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      overlayColor: Colors.transparent,
                                    ),
                                    onPressed: () {
                                      AppRouter.pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: AppTypography.mainCaption_1.copyWith(
                                        color: AppColors.darkGrey,
                                      ),
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
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
