import 'dart:io';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:foap/components/search_bar.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/manager/player_manager.dart';
import 'package:foap/segmentAndMenu/horizontal_menu.dart';
import 'package:get/get.dart';
import 'package:foap/helper/imports/reel_imports.dart';


class SelectMusic extends StatefulWidget {
  final Function(File, ReelMusicModel) selectedAudioCallback;

  const SelectMusic({Key? key, required this.selectedAudioCallback})
      : super(key: key);

  @override
  State<SelectMusic> createState() => _SelectMusicState();
}

class _SelectMusicState extends State<SelectMusic> {
  final CreateReelController _createReelController = Get.find();
  final PlayerManager _playerManager = Get.find();

  @override
  void initState() {
    super.initState();
    _createReelController.getReelCategories();
  }

  @override
  void didUpdateWidget(covariant SelectMusic oldWidget) {
    // exploreController.getSuggestedUsers();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _createReelController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColorConstants.backgroundColor,
      body: KeyboardDismissOnTap(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  const ThemeIconWidget(
                    ThemeIcon.backArrow,
                    size: 25,
                  ).ripple(() {
                    Get.back();
                  }),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SearchBar(
                        showSearchIcon: true,
                        hintText: LocalizationString.searchMusic,
                        iconColor: AppColorConstants.themeColor,
                        onSearchChanged: (value) {
                          _createReelController.searchTextChanged(value);
                        },
                        onSearchStarted: () {
                          //controller.startSearch();
                        },
                        onSearchCompleted: (searchTerm) {}),
                  ),
                  Obx(() => _createReelController.searchText.isNotEmpty
                      ? Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        color: AppColorConstants.themeColor,
                        child: ThemeIconWidget(
                          ThemeIcon.close,
                          color: AppColorConstants.backgroundColor,
                          size: 25,
                        ),
                      ).round(20).ripple(() {
                        _createReelController.closeSearch();
                      }),
                    ],
                  )
                      : Container())
                ],
              ).setPadding(left: 16, right: 16, top: 25, bottom: 20),
              GetBuilder<CreateReelController>(
                  init: _createReelController,
                  builder: (ctx) {
                    return Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          segmentView(),
                          divider(context: context, height: 0.2).tP25,
                          musicListView()
                          // searchedResult(segment: exploreController.selectedSegment),
                        ],
                      ),
                    );
                  })
            ],
          )),
    );
  }

  Widget segmentView() {
    return HorizontalMenuBar(
        padding: const EdgeInsets.only(left: 16),
        selectedIndex: _createReelController.selectedSegment,
        // width: MediaQuery.of(context).size.width,
        onSegmentChange: (segment) {
          _createReelController.segmentChanged(segment);
        },
        menus: _createReelController.categories
            .map((element) => element.name)
            .toList());
  }

  Widget musicListView() {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (!_createReelController.isLoadingAudios.value) {
          _createReelController.getReelAudios();
        }
      }
    });

    return _createReelController.isLoadingAudios.value
        ? Expanded(child: const ShimmerUsers().hP16)
        : _createReelController.audios.isNotEmpty
        ? Expanded(
      child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.only(
              top: 20, bottom: 50, left: 16, right: 16),
          itemCount: _createReelController.audios.length,
          itemBuilder: (BuildContext ctx, int index) {
            ReelMusicModel audio =
            _createReelController.audios[index];
            return Obx(() {
              return AudioTile(
                audio: audio,
                isPlaying:
                _playerManager.currentlyPlayingAudio.value?.id ==
                    audio.id.toString(),
                playCallBack: () {
                  _createReelController.playAudio(audio);
                },
                stopBack: () {
                  _createReelController.stopPlayingAudio();
                },
                useAudioBack: () {
                  if (_createReelController.recordingLength.value >
                      audio.duration) {
                    AppUtil.showToast(
                        message:
                        'Audio is shorter than ${_createReelController.recordingLength}seconds',
                        isSuccess: false);
                    return;
                  }
                  openCropAudio(audio);
                },
              );
            });
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(
              height: 20,
            );
          }),
    )
        : emptyData(
      title: 'No audio found',
      subTitle: 'Please search another audio',
    );
  }

  void openCropAudio(ReelMusicModel audio) async {
    _createReelController.selectReelAudio(audio);
    File audioFile = await Get.bottomSheet(FractionallySizedBox(
        heightFactor: 0.7, child: CropAudioScreen(reelMusicModel: audio)));
    widget.selectedAudioCallback(audioFile,audio);
    Get.back();
  }
}
