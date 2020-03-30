import 'package:coranapp/state/actions/actions.dart';
import 'package:coranapp/state/app-state.dart';
import 'package:coranapp/state/models.dart';
import 'package:redux/redux.dart';

class ViewModel {
  final Function(bool, CoranDataInfo) onPlay;
  final Function(bool) setIsLoading;
  final PlayStatus playStatus;
  final bool isLoading;
  ViewModel({
    this.playStatus,
    this.onPlay,
    this.isLoading,
    this.setIsLoading
  });

  factory ViewModel.create(Store<AppState> store) {
    _onPlay(isPlaying, coranDataInfo) {
      store.dispatch(PlayAction(isPlaying, coranDataInfo));
    }
    _setLoadingAction(isLoading) {
      store.dispatch(IsLoadingAction(isLoading));
    }

    return ViewModel(
      playStatus: store.state.playStatus,
      onPlay: _onPlay,
      isLoading: store.state.isLoading,
      setIsLoading: _setLoadingAction
    );
  }
}