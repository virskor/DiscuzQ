import 'package:assets_audio_player/assets_audio_player.dart';


///
/// 用于播放音效
class Sounds {
  ///
  /// 刷新音效
  ///
  static const String refresh = 'assets/sounds/refresh.mp3';


  ///
  /// 刷新音效
  ///
  static const String pop = 'assets/sounds/pop.mp3';


  ///
  /// 刷新音效
  ///
  static const String send = 'assets/sounds/send.mp3';


  ///
  /// 播放音频
  static void play(String url) {
    // call this method when desired
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
      Audio(url)
    );
    assetsAudioPlayer.play();
  }
}
