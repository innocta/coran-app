
import 'models.dart';

class PlayStatus {
  final bool isPlaying;
  final CoranDataInfo coranDataInfo;

  PlayStatus(this.isPlaying, this.coranDataInfo);
}

class AppState {
  final PlayStatus playStatus;

  AppState(this.playStatus);

  AppState.initialState() : playStatus = new PlayStatus(false, new CoranDataInfo(-1, "", "", "", 0.0));
}
