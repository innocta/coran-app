
import '../models.dart';

class PlayAction {
  bool isPlaying;
  CoranDataInfo coranDataInfo;

  PlayAction(this.isPlaying, this.coranDataInfo) {}
}

class IsLoadingAction {
  bool isLoading;

  IsLoadingAction(this.isLoading) {}
}