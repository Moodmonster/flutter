import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/config/routes/routes.dart';
import 'package:moodmonster/core/local/local_storage_keys.dart';
import 'package:moodmonster/feature/error/data_null_screen.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/helpers/constants/app_typography.dart';
import 'package:moodmonster/helpers/extensions/showdialog_helper.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/models/content_episode.model.dart';
import 'package:moodmonster/providers/episode_provider.dart';
import 'package:moodmonster/providers/novel_provider.dart';
import 'package:moodmonster/providers/webtoon_provider.dart';

//상단 오른쪽 메뉴 버튼에 들어갈 내용들
enum MenuType { Delete, Details }

class EpisodeListScreen extends ConsumerStatefulWidget {
  const EpisodeListScreen({super.key});

  @override
  ConsumerState<EpisodeListScreen> createState() => _EpisodeListScreenState();
}

class _EpisodeListScreenState extends ConsumerState<EpisodeListScreen> {
  Content? contentInfo;
  //호출 여부 플래그
  bool _initialized = false;

  //에피소드 목록 로드
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    contentInfo ??= ModalRoute.of(context)?.settings.arguments as Content?;

    // 최초 한 번만 실행
    if (!_initialized && contentInfo != null) {
      _initialized = true;

      // provider 상태 변경을 마이크로태스크로 지연시킴
      Future.microtask(() {
        ref
            .read(EpisodeProvider.notifier)
            .loadEpisodesByContentCode(
              contentType: contentInfo!.contentType,
              contentCode: contentInfo!.code,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //컨텐츠 정보를 바탕으로 에피소드 데이터 리스트들 가져온다
    if (contentInfo == null) {
      return DataNullScreen();
    }

    final episodeState = ref.watch(EpisodeProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: episodeState.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("에피소드 로딩 실패: $err")),
          data: (epList) => _buildEpisodeListScreenUI(contentInfo!, epList),
        ),
      ),
      //목차 추가 버튼 : 해당 콘텐츠 생성자가 본인일때만 보인다
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          contentInfo!.userId == PrefsKeys.userId
              ? FloatingActionButton(
                onPressed: () {
                  _showAlertForAddEpisode(
                    DialogTtitle: "에피소드 추가",
                    cancelMsg: "취소",
                    enterMsg: "확인",
                    contentInfo: contentInfo!,
                  );
                },
                child: Icon(Icons.add, color: AppColors.background),
                elevation: 10,
                backgroundColor: AppColors.mainTextColor,

                shape: CircleBorder(),
              )
              : null,
    );
  }

  Widget _buildEpisodeListScreenUI(
    Content contentInfo,
    List<ContentEpisode> epList,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //맨 위 썸네일사진
          Stack(
            children: [
              // 썸네일 사진
              contentInfo != null
                  ? Image.network(
                    contentInfo.thumbnailUrl,
                    width: double.infinity,
                    height: 290.h,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    //오류 발생 시 기본 파일 보이도록
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/imgs/default_img.jpg",
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      );
                    },
                  )
                  : Container(
                    width: double.infinity,
                    height: 220.h,
                    color: Colors.grey,
                  ),
              // 하단 그라데이션 겹치기
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 160.h, // 그라데이션 높이
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.background, // 아래쪽은 하얀색
                        Colors.black.withOpacity(0.0), // 위쪽은 투명
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //뒤로가기 버튼
                  InkWell(
                    onTap: () {
                      AppRouter.pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        size: 28.w,
                        shadows: <Shadow>[
                          Shadow(color: Colors.black, blurRadius: 10.0),
                        ],
                        Icons.arrow_back_ios_new,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  //메뉴 보기 버튼
                  MenuButtonInEpoisodeList(contentInfo: contentInfo),
                ],
              ),
            ],
          ),

          //제목, 작가, 소개 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              //mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 16.0,
                  runSpacing: 2.0,
                  children: [
                    Baseline(
                      baseline: 20.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        //콘텐츠 제목
                        contentInfo.title ?? "데이터 없음",
                        style: TextStyle(
                          color: AppColors.mainTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Baseline(
                      baseline: 20.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        contentInfo.author ?? "데이터 없음",
                        style: TextStyle(
                          color: AppColors.mainTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6.h),
                Text(
                  contentInfo.desc ?? "데이터 없음",
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: AppColors.mainTextColor,
                    fontSize: 12,
                    decoration: TextDecoration.none,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ),
          //전체 회차 개수 정보
          Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "총 ${epList.length}화",
                style: TextStyle(fontSize: 13, color: AppColors.descTextColor),
              ),
            ),
          ),
          //에피소드 목록 출력
          ListView.builder(
            itemCount: epList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return EpisodeListItem(
                key: ValueKey(epList[index].code),
                contentInfo: contentInfo,
                episodeInfo: epList[index],
              );
            },
          ),
        ],
      ),
    );
  }
}

//우측 상단 메뉴버튼
class MenuButtonInEpoisodeList extends ConsumerWidget {
  final Content? contentInfo;
  const MenuButtonInEpoisodeList({super.key, required this.contentInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (contentInfo == null) {
      return SizedBox();
    }
    return PopupMenuButton(
      icon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          size: 30.w,
          shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 10.0)],
          Icons.more_vert_rounded,
          color: AppColors.white,
        ),
      ),
      color: Colors.white,
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      onSelected: (MenuType result) {
        switch (result) {
          case MenuType.Delete:
            ShowDialogHelper.showAlertWithActionAndCancel(
              cancelMsg: "Cancel",
              enterMsg: "Ok",
              onPressed: () async {
                //로딩창 띄우기
                ShowDialogHelper.showLoadingWithMessage(
                  message: "콘텐츠를 삭제중입니다.",
                );
                try {
                  //콘텐츠가 소설이면
                  if (contentInfo?.contentType == MyContentType.Novel) {
                    await ref
                        .read(NovelProvider.notifier)
                        .removeNovel(code: contentInfo!.code); // 삭제 함수 호출
                  } else {
                    //콘텐츠가 웹툰이면
                    await ref
                        .read(WebtoonProvider.notifier)
                        .removeWebtoon(code: contentInfo!.code); // 삭제 함수 호출
                  }
                  ShowDialogHelper.closeLoading();
                  AppRouter.pop();

                  ShowDialogHelper.showSnackBar(content: "삭제 완료!");
                } catch (err) {
                  ShowDialogHelper.closeLoading();
                  ShowDialogHelper.showSnackBar(content: "에러 발생: $err");
                }
              },
              title: "Delete [ ${contentInfo!.title} ]?",
              message: "Are You Sure? \nYou Can't Cancel this action",
            );

            break;
          case MenuType.Details:
            // 다른 기능 처리
            break;
        }
      },
      itemBuilder: (BuildContext buildContext) {
        return MenuType.values
            .where(
              (value) =>
                  value != MenuType.Delete ||
                  contentInfo!.userId == PrefsKeys.userId,
            )
            .map(
              (value) => PopupMenuItem(
                value: value,
                child: Text(value.toString().split(".")[1]),
              ),
            )
            .toList();
      },
    );
  }
}

//목차 한줄 한줄 위젯
class EpisodeListItem extends StatelessWidget {
  final Content contentInfo;
  final ContentEpisode episodeInfo;
  const EpisodeListItem({
    super.key,
    required this.contentInfo,
    required this.episodeInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //하단 모서리 설정해서 아래 데이터랑 영역 나누기
        border: Border(
          bottom: BorderSide(width: 0.5.w, color: AppColors.lightBlack),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        //우측 삭제 버튼(작가가 본인일때만 보인다)
        trailing:
            (contentInfo.userId == PrefsKeys.userId)
                ? IconButton(
                  onPressed: () {
                    ShowDialogHelper.showAlertWithActionAndCancel(
                      onPressed: () async {
                        final episodeNotifier = ProviderScope.containerOf(
                          context,
                          listen: false,
                        ).read(EpisodeProvider.notifier);
                        //로딩창 띄우기
                        ShowDialogHelper.showLoadingWithMessage(
                          message: "에피스드를 삭제중입니다.",
                        );
                        //에피소드 삭제 호출
                        try {
                          await episodeNotifier.removeEpisode(
                            contentType: contentInfo.contentType,
                            episodeCode: episodeInfo.code,
                            contentCode: contentInfo.code,
                          );
                          ShowDialogHelper.closeLoading();
                          ShowDialogHelper.showSnackBar(
                            content: "에피소드 삭제 완료!",
                            backgroundColor: AppColors.primary,
                          );
                        } catch (e) {
                          ShowDialogHelper.closeLoading();
                          ShowDialogHelper.showSnackBar(content: "삭제 실패: $e");
                        }
                      },
                      title: "Delete [ ${episodeInfo.epTitle} ]?",
                      message: "Are You Sure? \nYou Can't Cancel this action",
                      enterMsg: "Ok",
                      cancelMsg: "Cancel",
                    );
                  },
                  icon: Icon(Icons.delete_outlined),
                )
                : null,

        leading:
            //웹툰은 회차마다 썸네일 보인다
            contentInfo.contentType == MyContentType.Webtoon
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    episodeInfo.thumbnailUrl,
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    //오류 발생 시 기본 파일 보이도록
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/imgs/default_img.jpg",
                        width: double.infinity,
                        height: 60.h,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      );
                    },
                  ),
                )
                : Container(
                  //웹소설은 목차 썸네일 없음
                  margin: EdgeInsets.only(left: 10.w),

                  width: 3.w, // 막대 두께
                  height: 30.h, // 막대 길이
                  color: AppColors.mainTextColor, // 색상
                ),
        title: Text(
          episodeInfo.epTitle,
          style: TextStyle(color: AppColors.mainTextColor, fontSize: 13),
        ),
        subtitle: Text(
          "${episodeInfo.uploadDate.toString().split(' ')[0]}", //년-월-일 까지만 표시
          style: TextStyle(color: AppColors.descTextColor, fontSize: 12),
        ),

        onTap: () {
          //선호 음악 프롬프트 입력 모달창 출력
          _showAlertWithTextFieldAndActionAndCancel(
            contentInfo: contentInfo,
            episodeInfo: episodeInfo,
            title: "음악 분위기 입력 ",
            message: "원하는 음악 분위기를 입력해주세요. \n 빈칸이면 알아서 생성됨",
            enterMsg: "확인",
            cancelMsg: "취소",
          );
          return;
          // 에피소드 상세 페이지로 이동
          //Navigator.pushNamed(context, '/episodeDetail', arguments: episodeInfo);
        },
      ),
    );
  }
}

///사용자로부터 값 입력 받을 수 있고 확인을 누르면 Action이 수행, 사용자가 임의로 취소 가능한 알림창
void _showAlertWithTextFieldAndActionAndCancel({
  required Content contentInfo,
  required ContentEpisode episodeInfo,
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
                      color: AppColors.descTextColor,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
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
            onPressed: () async {
              //모달창 닫기
              AppRouter.pop();
              //소설 내용 보는 화면으로 이동
              AppRouter.pushNamed(
                Routes.novelParagraphsShowScreen,
                args: {
                  'episodeInfo': episodeInfo,
                  'prompt': _SongMoodEnterController.text,
                  'contentInfo': contentInfo,
                },
              );
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

///에피소드 add할 때 사용할 모달창
void _showAlertForAddEpisode({
  required String DialogTtitle,
  required String enterMsg,
  required String cancelMsg,
  required Content contentInfo,
}) {
  final TextEditingController _titleController = TextEditingController();
  //사용자가 선택한 파일 저장 변수(앱용)
  File? selectedFile;
  //사용자가 선택한 파일 저장 변수(웹용)
  Uint8List? selectedFileInWeb;

  //사용자가 선택한 파일의 파일명
  String? selectedFileName;
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
                        0.7, // 화면 높이의 70%로 제한
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    width: 320.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("에피소드 제목", softWrap: true),

                            SizedBox(height: 5.h),
                            Flexible(
                              //width: 170.w,
                              fit: FlexFit.loose,
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
                            Text("파일 업로드", softWrap: true),

                            SizedBox(height: 5.h),
                            Flexible(
                              //width: 170.w,
                              fit: FlexFit.loose,
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
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'jpg',
                                              'jpeg',
                                              'png',
                                              'txt',
                                            ], // 원하는 확장자 추가
                                            withData:
                                                true, // 웹에서 bytes 사용을 위해 필요
                                          );

                                      if (result != null &&
                                          result.files.single.bytes != null) {
                                        setState(() {
                                          selectedFileName =
                                              result.files.single.name;

                                          if (kIsWeb) {
                                            selectedFileInWeb =
                                                result.files.single.bytes!;
                                          } else {
                                            selectedFile = File(
                                              result.files.single.path!,
                                            );
                                          }
                                        });
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
                                            "파일 업로드",
                                            style: TextStyle(
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if ((selectedFile != null ||
                                          selectedFileInWeb != null) &&
                                      selectedFileName != null)
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
                                            //선택한 파일 미리보기(이미지면)
                                            child:
                                                selectedFile != null
                                                    ? (selectedFileName!
                                                            .endsWith('.txt')
                                                        ? Center(
                                                          child: Icon(
                                                            Icons
                                                                .insert_drive_file_outlined,
                                                          ),
                                                        )
                                                        : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          child: Image.file(
                                                            selectedFile!,
                                                            fit: BoxFit.cover,
                                                            alignment:
                                                                Alignment
                                                                    .center,
                                                          ),
                                                        ))
                                                    : (selectedFileName!
                                                            .endsWith('.txt')
                                                        ? Center(
                                                          child: Icon(
                                                            Icons
                                                                .insert_drive_file_outlined,
                                                          ),
                                                        )
                                                        : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          child: Image.memory(
                                                            selectedFileInWeb!,
                                                            fit: BoxFit.cover,
                                                            alignment:
                                                                Alignment
                                                                    .center,
                                                          ),
                                                        )),
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
                                                  selectedFileName ?? "",
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
                                        (selectedFileName == null)) {
                                      _scaffoldMessengerKey.currentState
                                          ?.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "입력 안 된 값이 있습니다",
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
                                      //모든 값 입력 잘 되었다면
                                      final episodeNotifier =
                                          ProviderScope.containerOf(
                                            context,
                                            listen: false,
                                          ).read(EpisodeProvider.notifier);
                                      //로딩창 띄우기
                                      ShowDialogHelper.showLoadingWithMessage(
                                        message: "에피소드를 추가중입니다.",
                                      );
                                      try {
                                        if (selectedFile != null) {
                                          //파일이 모바일에서 업로드한 데이터면

                                          await episodeNotifier
                                              .addEpisodeInMobile(
                                                contentType:
                                                    contentInfo.contentType,
                                                contentCode: contentInfo.code,
                                                epTitle: _titleController.text,
                                                uploadDate: DateTime.now(),
                                                episodeFile: selectedFile!,
                                              );
                                        } //  파일가 웹에서 업로드한 데이터이고 파일명도 제대로 인식했으면
                                        else if (selectedFileInWeb != null &&
                                            selectedFileName != null) {
                                          await episodeNotifier.addEpisodeInWeb(
                                            contentType:
                                                contentInfo.contentType,
                                            contentCode: contentInfo.code,
                                            epTitle: _titleController.text,
                                            uploadDate: DateTime.now(),
                                            episodeFileInWeb:
                                                selectedFileInWeb!,
                                            episodeFileNameInWeb:
                                                selectedFileName!,
                                          );
                                        } else {
                                          _scaffoldMessengerKey.currentState
                                              ?.showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "파일 선택에 문제가 있습니다",
                                                  ),
                                                ),
                                              );

                                          return;
                                        }
                                        ShowDialogHelper.closeLoading();
                                        AppRouter.pop();
                                        ShowDialogHelper.showSnackBar(
                                          content: "추가 완료!",
                                          backgroundColor: AppColors.primary,
                                        );
                                      } catch (err) {
                                        //오류 발생시 스낵바 띄움
                                        ShowDialogHelper.closeLoading();
                                        print(err);
                                        _scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                              SnackBar(content: Text("에러 발생!")),
                                            );
                                      }

                                      //onPressed();
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
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
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
              ),
            ),
          );
        },
      );
    },
  );
}
