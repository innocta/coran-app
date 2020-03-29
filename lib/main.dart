import 'package:audioplayer/audioplayer.dart';
import 'package:coranapp/state/actions/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'coran-data.dart';
import 'choise.dart';
import 'state/app-state.dart';
import 'state/reducers/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
    );
    return StoreProvider<AppState>(
        store: store,
        child: new MaterialApp(
          title: 'Coran App',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.lightGreen,
          ),
          home: StoreConnector<AppState, _ViewModel>(
            converter: (Store<AppState> store) => _ViewModel.create(store),
            builder: (BuildContext context, _ViewModel viewModel) => DefaultTabController(
              length: choices.length,
              child: Scaffold(
                  appBar: AppBar(
                    title: const Text('القرآن الكريم'),
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: choices.map((Choice choice) {
                        return Tab(
                          text: choice.title,
                          icon: Icon(choice.icon),
                        );
                      }).toList(),
                    ),
                  ),
                  body: TabBarView(
                    children: choices.map((Choice choice) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ChoiceCard(choice, viewModel),
                      );
                    }).toList(),
                  ),
                  bottomNavigationBar: BuildBottomFooter(viewModel)
              ),
            ),
          ),
        )
    );
  }
}

class _ViewModel {
  final PlayStatus playStatus;
  final Function(bool) onPlay;

  _ViewModel({
    this.playStatus,
    this.onPlay,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onPlay(isPlaying) {
      store.dispatch(PlayAction(isPlaying));
    }

    return _ViewModel(
      playStatus: store.state.playStatus,
      onPlay: _onPlay,
    );
  }
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'سورة', icon: Icons.album),
  const Choice(title: 'أحزاب', icon: Icons.arrow_drop_down_circle),
  const Choice(title: 'اثمان', icon: Icons.trip_origin),
];

class BuildBottomFooter extends StatefulWidget {
  final _ViewModel model;

  @override
  State<StatefulWidget> createState() {
    return _BuildBottomFooterState();
  }
  BuildBottomFooter(this.model) {}
}

class _BuildBottomFooterState extends State<BuildBottomFooter> {

  buildIcon () {
    print(widget.model.playStatus.isPlaying);
    if (widget.model != null && widget.model.playStatus.isPlaying) {
        return new Icon(Icons.pause);
    }
    return new Icon(Icons.play_arrow);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(icon: new Icon(Icons.fast_rewind), onPressed: () => {}),
              new IconButton(icon: buildIcon(), onPressed: () => {}),
              new IconButton(icon: new Icon(Icons.fast_forward), onPressed: () => {}),
            ],
          ),
          subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("surat"),
              ]
          )
      ),
    );
  }

}


class ChoiceCard extends StatefulWidget {
  final Choice choice;
  final _ViewModel model;

  @override
  State<StatefulWidget> createState() {
    return _ChoiceCardState(this.choice);
  }
  ChoiceCard(this.choice, this.model) {}
}

enum PlayerState { stopped, playing, paused }


class _ChoiceCardState extends State<ChoiceCard> {
  AudioPlayer audioPlayer = new AudioPlayer();

  final Choice choice;
  CoranData coranData;
  PlayerState playerState = PlayerState.stopped;
  int id = -1;

  _ChoiceCardState(this.choice) {
    this.coranData = new CoranData();
  }

  Widget _buildSuggestions(dynamic listOfContents) {
    return new ListView.builder(
        itemCount: listOfContents.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (con2text, i) {
          return _buildRow(listOfContents[i], i + 1);
        });
  }

  Future<void> play(int id, String url) async {
    String coranUrl = "http://innocta.de/assets/" + url;
    print(coranUrl);
    await audioPlayer.play(coranUrl);
    widget.model.onPlay(true);
    setState(() {
      playerState = PlayerState.playing;
      this.id = id;
    });
  }

  Future<void> pause(int id) async {
    await audioPlayer.pause();
    widget.model.onPlay(false);
    setState(() {
      playerState = PlayerState.paused;
      this.id = id;
    });
  }

  Future<void> stop(int id) async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      this.id = id;
    });
  }

  buildIcon (coranDataInfo) {
    if (coranDataInfo['id'] == this.id) {
      if ((this.playerState == PlayerState.stopped || this.playerState == PlayerState.paused))
        return new Icon(Icons.play_arrow);
      else
        return new Icon(Icons.pause);
    }
    return new Icon(Icons.play_arrow);
  }

  Widget _buildRow(dynamic coranDataInfo, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(coranDataInfo['title']),
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(coranDataInfo['artist']),
                ),
              ],
            ),
            leading: new IconButton(
              icon: buildIcon(coranDataInfo),
              highlightColor: Colors.pink,
              onPressed: (){
                if (this.playerState == PlayerState.stopped || this.playerState == PlayerState.paused)
                  play(coranDataInfo['id'], coranDataInfo['url']);
                else if (this.playerState == PlayerState.playing)
                  pause(coranDataInfo['id']);
              },

            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch(choice.title) {
      case "سورة":
        return _buildSuggestions(this.coranData.surats);
      case "أحزاب":
        return _buildSuggestions(this.coranData.ahzab);
      case "اثمان":
        return _buildSuggestions(this.coranData.athman);

    }
  }
}