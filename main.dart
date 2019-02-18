import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kitchen_app/Model.dart/actions.dart';
import 'package:kitchen_app/Model.dart/model.dart';
import 'package:kitchen_app/Model.dart/reducers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:kitchen_app/Model.dart/middleWare.dart';
import 'package:intl/intl.dart';
import "UI/productContainer.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final Store<AppState> store = Store<AppState>(
    //   appStateReducer,
    //   initialState: AppState.initialState(),
    // );
    final store = new Store<AppState>(
      appReducer,
      initialState: new AppState.initialState(),
      middleware: createMiddleWares(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
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
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hii yoyaa'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Column(children: <Widget>[
                  UI(),
                  // ListOutput(),
                ]),
              ),
            ],
          ),
        ));
  }
}

class UI extends StatefulWidget {
  UI({Key key, this.title}) : super(key: key);

  final String title;

  @override
  UIState createState() => new UIState();
}

class UIState extends State<UI> {
  TextEditingController textEditingController = new TextEditingController();
  String photoUrl =
      'https://cdn.arstechnica.net/wp-content/uploads/2018/09/Screen-Shot-2018-09-21-at-3.36.21-PM-800x597.png';

  File choosenphoto;

  @override
  void initState() {
    super.initState();
    textEditingController = new TextEditingController();

    print(textEditingController.text);
  }

  Future imageSelectorGallery() async {
    File gall = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    print("thee functionnow finished");

    setState(() {
      choosenphoto = gall;
    });
  }

  imageSelectorCamera() async {
    File cam = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      choosenphoto = cam;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (store) => ViewModel.create(store),
        builder: (context, model) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                // Center(
                Container(
                  height: 250.0,
                  width: 100.0,
                  child: CircleAvatar(
                      radius: 0.3,
                      backgroundImage: choosenphoto == null
                          ? NetworkImage(photoUrl)
                          : FileImage(choosenphoto),
                      child: GestureDetector(
                          child: Center(
                            child: Icon(Icons.camera_alt),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (_) => Container(
                                    height: 112.0,
                                    child: Center(
                                      child: Builder(
                                          builder: (context) =>
                                              Column(children: <Widget>[
                                                Center(
                                                  child:
                                                      Column(children: <Widget>[
                                                    FlatButton(
                                                      color: Colors.green,
                                                      child: Center(
                                                          child:
                                                              Text("camera")),
                                                      onPressed: () {
                                                        imageSelectorCamera();
                                                        model.editphotocam(
                                                            choosenphoto);
                                                        Navigator.pop(context);

                                                        print("camera");
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Center(
                                                          child:
                                                              Text("Gallery")),
                                                      color: Colors.yellow,
                                                      onPressed: () {
                                                        imageSelectorGallery();

                                                        Navigator.pop(context);
                                                        model.editphotogall(
                                                            choosenphoto);
                                                        print("Gallery");
                                                      },
                                                    )
                                                  ]),
                                                ),
                                              ])),
                                    )));
                          })),
                ),
                SizedBox(height: 15.0),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter User Name here",
                      prefixIcon: Icon(Icons.person)),
                  controller: textEditingController,
                  onSubmitted: (String s) {
                    print(s);

                    model.editname(s);
                    textEditingController.text = s;
                  },
                ),
                FlatButton(child: Text("savedata"), onPressed: () => null)
              ],
            ),
          );
        });
  }
}

// class ListOutput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, ViewModel>(
//       converter: (store) => ViewModel.create(store),
//       builder: (context, viewModel) => Container(
//             width: 150.0,
//             child: Text((viewModel.user.name) ?? (" ")),
//           ),
//     );
//   }
// }

class ViewModel {
  final Function(String) editname;
  final Function(File) editphotocam, editphotogall;

  final User user;

  ViewModel({this.editname, this.user, this.editphotocam, this.editphotogall});
  factory ViewModel.create(Store<AppState> store) {
    _onAddItem(String inputtext) {
      store.dispatch(
        EditName(name: inputtext),
      );
    }

    _onAddCam(File val) {
      store.dispatch(AddPhotoFromCam(cam: val));
    }

    _onAddGall(File val) {
      store.dispatch(AddPhotoFromGall(gall: val));
    }

    return ViewModel(
        editname: _onAddItem,
        user: store.state.user,
        editphotocam: _onAddCam,
        editphotogall: _onAddGall);
  }
}
