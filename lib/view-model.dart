import 'package:coranapp/state/actions/actions.dart';
import 'package:coranapp/state/app-state.dart';
import 'package:coranapp/state/models.dart';
import 'package:redux/redux.dart';

class ViewModel {
  final Function(bool, CoranDataInfo) onPlay;
  final PlayStatus playStatus;
  ViewModel({
    this.playStatus,
    this.onPlay,
  });

  factory ViewModel.create(Store<AppState> store) {
    _onPlay(isPlaying, coranDataInfo) {
      store.dispatch(PlayAction(isPlaying, coranDataInfo));
    }

    return ViewModel(
      playStatus: store.state.playStatus,
      onPlay: _onPlay,
    );
  }
}