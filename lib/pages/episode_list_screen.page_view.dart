import 'package:flutter/material.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/dumyData/contentEpisodeDumyData.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/helpers/extensions/showdialog_helper.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/models/content_episode.model.dart';

class EpisodeListScreen extends StatelessWidget {
  const EpisodeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ContentEpisode> epList = [];
    final Content? contentInfo =
        ModalRoute.of(context)?.settings.arguments as Content?;
    // final Content? contentInfo = Content(
    //   4,
    //   "김부장",
    //   "“제발 안경 쓴 아저씨는 건들지 말자…”\n오직 자신의 딸 '민지'를 위해 특수요원직을 관두고 평범함을 선택한 가장 김부장.\n그러던 어느 날 민지가 소리소문 없이 사라지고, 김부장은 자신을 감시하는 국가를 적으로 돌리면서까지 딸을 찾아나서기 시작하는데...\n[외모지상주의], [싸움독학] 그리고 [인생존망]의 세계관을 잇는 공식 스핀오프 작품!",
    //   "박만사",
    //   Days.tue,
    //   9.61,
    //   false,
    //   false,
    //   "../assets/imgs/thumbnail_IMAG21_d7732f14-26da-4e35-8762-660cc87b53f1.jpg",
    // );

    //컨텐츠 정보를 바탕으로 에피소드 데이터 리스트들 가져온다
    if (contentInfo != null) {
      epList =
          ContentEpisodeDumyData.where(
            (data) => data.contentCode == contentInfo.code,
          ).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //맨 위 웹툰사진
            Stack(
              children: [
                //웹툰 썸네일 사진
                contentInfo != null
                    ? Image.asset(
                      contentInfo.thumbnailUrl,
                      width: double.infinity,
                      height: 240,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    )
                    : Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey,
                    ),
                // 하단 그라데이션 겹치기
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120, // 그라데이션 높이
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.background, // 아래쪽은 짙은 검은색
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
                          shadows: <Shadow>[
                            Shadow(color: Colors.black, blurRadius: 10.0),
                          ],
                          Icons.arrow_back_ios_new,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          shadows: <Shadow>[
                            Shadow(color: Colors.black, blurRadius: 10.0),
                          ],
                          Icons.more_vert_rounded,
                          color: AppColors.white,
                        ),
                      ),
                    ),
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
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 16.0,
                    runSpacing: 2.0,
                    children: [
                      Baseline(
                        baseline: 20.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
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

                  SizedBox(height: 6),
                  Text(
                    contentInfo?.desc ?? "데이터 없음",
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: Colors.white70,
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
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ),
            ),
            //에피소드 목록 출력
            ListView.builder(
              itemCount: epList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return EpisodeListItem(episodeInfo: epList[index]);
              },
            ),
          ],
        ),
      ),
      //목차 추가 버튼
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, color: AppColors.background),
        elevation: 10,
        backgroundColor: AppColors.mainTextColor,

        shape: CircleBorder(),
      ),
    );
  }
}

class EpisodeListItem extends StatelessWidget {
  final ContentEpisode episodeInfo;
  const EpisodeListItem({super.key, required this.episodeInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(217, 49, 49, 49),
        border: Border(
          bottom: BorderSide(width: 1, color: AppColors.lightBlack),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),

        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            episodeInfo.thumbnailUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          episodeInfo.epTitle,
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
        subtitle: Text(
          "${episodeInfo.uploadDate.toString().split(' ')[0]}", //년-월-일 까지만 표시
          style: TextStyle(color: Colors.white70, fontSize: 12),
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
