import 'package:coranapp/view-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'audio-player-controller.dart';
import 'choise-card.dart';
import 'choise.dart';
import 'choises.dart';
import 'coran-data.dart';
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
    CoranData coranData = new CoranData();
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
          home: StoreConnector<AppState, ViewModel>(
            converter: (Store<AppState> store) => ViewModel.create(store),
            builder: (BuildContext context, ViewModel viewModel) => DefaultTabController(
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
                        child: ChoiceCard(choice, viewModel, coranData),
                      );
                    }).toList(),
                  ),
                  bottomNavigationBar: AudioPlayerController(viewModel, coranData)
              ),
            ),
          ),
        )
    );
  }
}

