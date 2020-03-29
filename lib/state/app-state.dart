
class PlayStatus {
  final bool isPlaying;

  PlayStatus(this.isPlaying);
}

class AppState {
  final PlayStatus playStatus;

  AppState(this.playStatus);

  AppState.initialState() : playStatus = new PlayStatus(false);
}
