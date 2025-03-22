import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/core/local/local_storage_keys.dart';
import 'package:moodmonster/dumyData/contentEpisodeDumyData.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/helpers/extensions/showdialog_helper.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/models/content_episode.model.dart';
import 'package:moodmonster/providers/novel_provider.dart';
import 'package:moodmonster/providers/webtoon_provider.dart';

//상단 오른쪽 메뉴 버튼에 들어갈 내용들
enum MenuType { Delete, Details }

class EpisodeListScreen extends StatelessWidget {
  const EpisodeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ContentEpisode> epList = [];
    final Content? contentInfo =
        ModalRoute.of(context)?.settings.arguments as Content?;

    //컨텐츠 정보를 바탕으로 에피소드 데이터 리스트들 가져온다
    if (contentInfo != null) {
      epList =
          ContentEpisodeDumyData.where(
            (data) => data.contentCode == contentInfo.code,
          ).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        alignment: Alignment.topCenter,
                        //오류 발생 시 기본 이미지 보이도록
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/imgs/default_img.jpg",
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16,
                ),
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
                            contentInfo?.title ?? "데이터 없음",
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
                            contentInfo?.author ?? "데이터 없음",
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
                      contentInfo?.desc ?? "데이터 없음",
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
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.descTextColor,
                    ),
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
                    contentInfo: contentInfo!,
                    episodeInfo: epList[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      //목차 추가 버튼 : 해당 콘텐츠 생성자가 본인일때만 보인다
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          contentInfo?.userId == PrefsKeys.userId
              ? FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add, color: AppColors.background),
                elevation: 10,
                backgroundColor: AppColors.mainTextColor,

                shape: CircleBorder(),
              )
              : null,
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
        contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),

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
                    //오류 발생 시 기본 이미지 보이도록
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/imgs/default_img.jpg",
                        width: double.infinity,
                        height: 60.h,
                        fit: BoxFit.cover,
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
          ShowDialogHelper.showAlertWithTextFieldAndActionAndCancel(
            onPressed: () {},
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
