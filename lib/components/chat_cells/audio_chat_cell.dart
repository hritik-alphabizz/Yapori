import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:foap/helper/imports/chat_imports.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:get/get.dart';

import '../../manager/player_manager.dart';

class AudioChatTile extends StatefulWidget {
  final ChatMessageModel message;

  const AudioChatTile({Key? key, required this.message}) : super(key: key);

  @override
  State<AudioChatTile> createState() => _AudioChatTileState();
}

//addon comment changes size and color & single play audio

class _AudioChatTileState extends State<AudioChatTile> {
  final PlayerManager _playerManager = Get.find();

  @override
  void initState() {
    super.initState();
  }

  playAudio() {
    Audio audio = Audio(
        id: widget.message.localMessageId,
        url: widget.message.mediaContent.audio!);
    _playerManager.playAudio(audio);
  }

  stopAudio() {
    _playerManager.stopAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //addon comment
                //_playerManager.currentlyPlayingAudio.value?.id == widget.message.id.toString()
                _playerManager.currentlyPlayingAudio.value?.id ==
                        widget.message.localMessageId.toString()
                    ?  ThemeIconWidget(
                        ThemeIcon.stop,
                        color: widget.message.isMineMessage ? AppColorConstants.grayscale900 : AppColorConstants.whiteClr,
                        size: 30,
                      ).ripple(() {
                        stopAudio();
                      })
                    :  ThemeIconWidget(
                        ThemeIcon.play,
                        color: widget.message.isMineMessage ? AppColorConstants.grayscale900 : AppColorConstants.whiteClr,
                        size: 30,
                      ).ripple(() {
                        playAudio();
                      }),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: 20,
                  child: AudioProgressBar(message: widget.message),
                ),
                const SizedBox(width: 20)
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
//addon comment progress bar related changes
class AudioProgressBar extends StatelessWidget {

  final ChatMessageModel message;

  final PlayerManager _playerManager = Get.find();

  AudioProgressBar({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => ProgressBar(
        thumbColor: message.isMineMessage ? AppColorConstants.themeColor.darken() : AppColorConstants.grayscale200,
        progressBarColor: message.isMineMessage ? AppColorConstants.themeColor : AppColorConstants.grayscale400,
        baseBarColor: message.isMineMessage ? AppColorConstants.grayscale300 : AppColorConstants.whiteClr,
        thumbRadius: 8,
        barHeight: 2,
        //_playerManager.progress.value?.current ?? const Duration(seconds: 0)
        progress: _playerManager.currentlyPlayingAudio.value?.id == message.localMessageId.toString() ? _playerManager.progress.value?.current ??
            const Duration(seconds: 0) : const Duration(seconds: 0),
        // buffered: value.buffered,
        //_playerManager.progress.value?.total ?? const Duration(seconds: 0)
        total: _playerManager.currentlyPlayingAudio.value?.id == message.localMessageId.toString() ? _playerManager.progress.value?.total ?? _playerManager.progress.value?.total ??
            const Duration(seconds: 0) : const Duration(seconds: 0),
        timeLabelPadding: 5,
        timeLabelTextStyle: TextStyle(
          //added color:message.isMineMessage ? AppColorConstants.grayscale900 : AppColorConstants.whiteClr
            fontSize: FontSizes.b4, fontWeight: TextWeight.bold,color:message.isMineMessage ? AppColorConstants.grayscale900 : AppColorConstants.whiteClr)

      // onSeek: pageManager.seek,
    ),);
  }
}
