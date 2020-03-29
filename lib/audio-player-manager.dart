import 'package:audioplayer/audioplayer.dart';
import 'package:coranapp/state/models.dart';
import 'package:coranapp/view-model.dart';

class AudioPlayerManager {
  AudioPlayer audioPlayer;
  String coranBaseURL;
  final ViewModel model;


  AudioPlayerManager(this.model) {
    this.audioPlayer  = new AudioPlayer();
    this.coranBaseURL = "http://innocta.de/assets/";
  }

  Future<void> play(CoranDataInfo coranDataInfo) async {
    String coranUrl = coranBaseURL + coranDataInfo.url;
    print(coranUrl);
    await audioPlayer.play(coranUrl);
    model.onPlay(true, coranDataInfo);
  }

  Future<void> pause(CoranDataInfo coranDataInfo) async {
    await audioPlayer.pause();
    model.onPlay(false, coranDataInfo);
  }

  Future<void> stop(int id) async {
    await audioPlayer.stop();
  }
}