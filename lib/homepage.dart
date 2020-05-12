import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:beyondthemelody/utilities/keys.dart';
import 'package:beyondthemelody/youtube/screens/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  bool isLoading = false;
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );
    return result;
  }

  Future<http.Response> getEmotion(File image) async {
    File compressedImage = await testCompressAndGetFile(
        image, image.parent.absolute.path + '/temp.jpg');
    return await http.post(
      'https://centralindia.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceAttributes=emotion',
      headers: <String, String>{
        'Content-Type': 'application/octet-stream',
        'Ocp-Apim-Subscription-Key': kAzureApiKey,
      },
      body: compressedImage.readAsBytesSync(),
    );
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    http.Response response = await getEmotion(_image);
    String emotion;
    dynamic valueEmotion = 0;
    String data = response.body;
    print(data);
    print(data.length);

    if (response.statusCode == 200 && data.length!=2) {
      List<dynamic> decodedData = jsonDecode(data);
      Map<String, dynamic> emotionMap =
          decodedData[0]['faceAttributes']['emotion'];
      print(emotionMap);
      emotionMap.forEach((key, value) {
        if (value > valueEmotion) {
          valueEmotion = value;
          emotion = key;
        }
      });
      print(emotion);
      setState(() {
        isLoading = false;
      });
      _onAlertButtonsPressed(context, emotion);
    } else{
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      _onAlertButtonPressed(context);
    }
  }

  _onAlertButtonsPressed(context, String emotion) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "ALERT",
      desc: "Emotion detected was $emotion",
      buttons: [
        DialogButton(
          child: Text(
            "CONFIRM",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen(emotion))),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "RETRY",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "ALERT",
      desc: "No emotion was detected. Please try again.",
      buttons: [
        DialogButton(
          child: Text(
            "Retry",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
  _onBasicAlertPressed(context) {
    Alert(
        context: context,
        title: "INFO",
        desc: "The app can detect the following emotions: anger, contempt, disgust, fear, happiness, neutral, sadness, surprise")
        .show();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text('Home',style: TextStyle(
          color:Color(0xFF63FFDA),
        ),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info,color: Color(0xFF63FFDA),),
            onPressed:(){setState(() {
              _onBasicAlertPressed(context);
            });
            }
          )
        ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
//        bottomNavigationBar: BottomNavigationBar(
//          items: [
//            BottomNavigationBarItem(
//              icon: Icon(Icons.face),
//              title: Text('Emotion'),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.music_note),
//              title: Text('Local Storage'),
//            )
//          ],
//        ),
        body: //_futureEmotion == null ?
            ModalProgressHUD(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            Expanded(flex: 1,
//                child: Container(
//                  child: Center(child: Text('How are you feeling today?',
//                  style: TextStyle(
//                    color: Color(0xFF63FFDA),
//                    fontSize: 30,
//                  ),)),
//                )),
              Expanded(
                flex: 10,
                child: Container(
                  child: Center(
                    child: _image == null
                      ? Text('No image selected')
//                        ? FittedBox(child: Image.asset('images/emotion.jpg')
//                    ,fit: BoxFit.fill,)
                        //: Image.file(_image),
                        : Image.file(_image),
//                    FlatButton(
//                            child: Text('confirm'),
//                            onPressed: () => getData(),
//                          ),
                  ),
                ),
              ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 150,
                    child: FlatButton(
                    color: Color(0xFF63FFDA),
                    textColor: Colors.black,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(3.0),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                     // side: BorderSide(color: Colors.red)
                    ),
                    onPressed:_image == null ? null :
                      (){
                      getData();
                      },
                    child: Text(
                      "Confirm",
                      style: TextStyle(fontSize: 20.0),
                    ),
                ),
                ),
              ),
            )
          ],
        ),
           inAsyncCall: isLoading, ),
      ),
    );
  }
}
