import 'package:coranapp/state/actions/actions.dart';
import '../app-state.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    playReducer(state.playStatus, action),
  );
}

PlayStatus playReducer(PlayStatus state, action) {
  if (action is PlayAction) {
    return new PlayStatus(action.isPlaying);
  }
  return state;
}
