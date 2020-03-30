import 'package:coranapp/state/actions/actions.dart';
import '../app-state.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    playReducer(state.playStatus, action),
    isLoadingReducer(state.isLoading, action),
  );
}

PlayStatus playReducer(PlayStatus state, action) {
  if (action is PlayAction) {
    return new PlayStatus(action.isPlaying, action.coranDataInfo);
  }
  return state;
}
bool isLoadingReducer(bool state, action) {
  if (action is IsLoadingAction) {
    return action.isLoading;
  }
  return state;
}
