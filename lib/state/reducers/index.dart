import 'package:coranapp/state/actions/actions.dart';
import '../app-state.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    playReducer(state.playStatus, action),
  );
}

PlayStatus playReducer(PlayStatus state, action) {
  if (action is PlayAction) {
    print("action is occured");
    return new PlayStatus(action.isPlaying, action.coranDataInfo);
  }
  return state;
}
