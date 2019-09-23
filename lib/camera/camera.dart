import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:image_picker/image_picker.dart';

class CameraWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: "Camera App",
      theme: new ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
      ),
      home: new MyImagePage(),
    );
  }
}

class MyImagePage extends StatefulWidget{
  @override
  _MyImagePageState createState() => _MyImagePageState();
}

class _MyImagePageState extends State<MyImagePage>{
  ui.Image targetimage;
  File imageFile;
  Size mediasize;
  //　選択フラグ
  var pressAttention = new List.generate(4, (i)=>false);
  var selectMark = '';

  GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    mediasize = MediaQuery.of(context).size;
    return Scaffold(
     appBar: AppBar(
       leading: Icon(Icons.arrow_back),
       title: Text("編集中"),
       actions: <Widget>[
         FlatButton(
          textColor: Colors.white,
          onPressed: () {},
          child: Text("次へ"),
          shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        ),
       ],
     ),
      body: SafeArea(
        child: GestureDetector(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // マーク選択
              Row(children: <Widget>[
                  Expanded(
                    child: Center(
                      child:FlatButton(
                        child: Text("S",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: pressAttention[0] ?  Colors.blue: Color(0xFF303030),
                            )
                        ),
                        onPressed:() => setState(() => selectArtIcon(0,'start')),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child:FlatButton(
                        child: Text("G",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: pressAttention[1] ? Colors.blue: Color(0xFF303030),
                            )
                        ),
                      onPressed:() => setState(() => selectArtIcon(1,'gole')),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        child: RotationTransition(
                          child: Icon(
                            Icons.radio_button_unchecked,
                            color: pressAttention[2] ? Colors.blue: Color(0xFF303030),
                          ),
                          turns: new AlwaysStoppedAnimation(135 / 360),
                        ),
                        onTap:() => setState(() => selectArtIcon(2,'maru')),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        child: RotationTransition(
                          child: Icon(
                            Icons.label_outline,
                            color: pressAttention[3] ? Colors.blue: Color(0xFF303030),
                          ),
                          turns: new AlwaysStoppedAnimation(135 / 360),
                        ),
                        onTap:() => setState(() => selectArtIcon(3,'label')),
                      ),
                    ),
                  ),
                ],
              ),
              // 写真表示箇所
              GestureDetector(
                onTapUp: _onTapUp,
                onLongPressStart: _onLongPressStart,
                onLongPressMoveUpdate: _onPointerMove,
                onLongPressEnd: _onLongPressEnd,
                onScaleUpdate: _onScaleUpdate,
                onScaleEnd: _onScaleEnd,
                onScaleStart: _onScaleStart,
                child:SafeArea(
                  child: Container(
                    child: CustomPaint(
                      key: _canvasKey,
                      painter: ImagePainter(targetimage, marks, imageFile),
                    ),
                    color: Colors.grey,
                    height: mediasize.height*0.7,
                    width: mediasize.width,
                    
                  ),
                ),
              ),
              // 画像加工完了ボタン
              Row(children: <Widget>[
                Expanded(child: GestureDetector(
                    child: Icon(Icons.close),
                    onTapUp: _onReset,
                  ),
                ),
                Expanded(child: Container(
                    child: Icon(Icons.check_box)
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
      // 編集ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: _showModalBottomSheet,
        child: Icon(Icons.playlist_add),
      ),
    );
  }
  
  void selectArtIcon(number,name){
    for(var i = 0; i < pressAttention.length; i++) {
      pressAttention[i] = false;
    }
    pressAttention[number] = true;
    selectMark = name;
  }

  void _showModalBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('カメラ'),
              onTap: () {
                Navigator.pop(context);
                getCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.filter),
              title: Text('画像'),
              onTap: () {
                Navigator.pop(context);
                getImage();
              },
            ),
          ],
        );
      },
    );
  }

  void getCamera() async{
    if(this.imageFile == null){
      File file = await ImagePicker.pickImage(source: ImageSource.camera);
      this.imageFile = file;
      loadImage(file);
    }else{
      ImagePainter.ms(targetimage, marks, imageFile, mediasize).saveImage();
    }
  }
  void getImage() async{
    if(this.imageFile == null){
      File file = await ImagePicker.pickImage(source: ImageSource.gallery);
      this.imageFile = file;
      loadImage(file);
    }else{
      ImagePainter.ms(targetimage, marks, imageFile, mediasize).saveImage();
    }
  }
  void loadImage(File image) async{
    List<int> byts = await image.readAsBytes();
    Uint8List u8lst = Uint8List.fromList(byts);
    ui.instantiateImageCodec(u8lst).then((codec){
      codec.getNextFrame().then((frameInfo){
        setState(() {
          targetimage = frameInfo.image;
          marks = List<Mark>();
        });
      });
    });
  }


  Mark nowMark = null;
  List<Mark> marks = new List<Mark>();
  var longPressFlag = false;
  var bindIcon;

  // タップが離れたときの処理
  void _onTapUp(TapUpDetails details) {
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    // ロングタップを防ぐための分岐
    if(longPressFlag == false){
      nowMark = new Mark(referenceBox.globalToLocal(details.globalPosition), 20 , selectMark);
      setState(() {
        marks.add(nowMark);
      });
    }
    // 画面から指が離れたときフラグを解除する
    longPressFlag = false;
  }

  // ロングタップを検知して、アイコンを移動できるフラグを変更
  void _onLongPressStart(LongPressStartDetails details){
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    var touchPostion = referenceBox.globalToLocal(details.globalPosition);
    // タップした箇所にアイコンがあるか判定
    Iterable inReverse = marks.reversed;
    var marksInReverse = inReverse.toList();
    bindIcon = marksInReverse.lastWhere((icon) => 
      sqrt(pow((icon.offset.dx - touchPostion.dx).abs().toDouble(), 2) + pow((icon.offset.dy - touchPostion.dy).abs().toDouble(), 2)) < 20);
    setState(() {
      longPressFlag = true;  
      //対象のアイコンがある場合は大きくする処理
    });
  }

  // ロングタップを終了したとき
  void _onLongPressEnd(LongPressEndDetails details){
    setState(() {
      longPressFlag = false;
    });
  }

  // ロングタップ中に移動させる処理
  void _onPointerMove(LongPressMoveUpdateDetails details) {
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    var touchPostion = referenceBox.globalToLocal(details.globalPosition);
    setState(() {
        // 要素を移動させる処理
        bindIcon.offset = touchPostion;
    });
  }

  // リセット処理
  void _onReset(TapUpDetails details){
    setState(() {
      marks = List<Mark>();
    });
  }

  double basescale = 1;
  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      nowMark.scale = details.scale*basescale;
    });
  }
  void _onScaleEnd(ScaleEndDetails details){

  }
  void _onScaleStart(ScaleStartDetails details){
    basescale = nowMark.scale;
  }


}


class Mark {
  Offset offset;
  double scale;
  String selectMark;

  Mark(this.offset, this.scale, this.selectMark);

  void drawToCanvas(Canvas canvas){
    if(this.selectMark == 'maru'){
      printMaru(canvas);
    }else if(this.selectMark == 'start'){
      drawS(canvas);
    }else if(this.selectMark == 'gole'){
      drawG(canvas);
    }else if(this.selectMark == 'label'){
      drawLabel(canvas);
    }
  }
  void printMaru(Canvas canvas){
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.blue //いる
      ..strokeWidth = 5.0 //いる
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(this.offset, this.scale, paint); //いる
  }

  void drawS(Canvas canvas){
    var textStyle = TextStyle(
      color: Colors.blue,
      fontSize: 20,
    );
    var textSpan = TextSpan(
      text: 'S',
      style: textStyle,
    );
    var textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 20,
    );
    textPainter.paint(canvas, this.offset);
  }

  void drawG(Canvas canvas){
    var textStyle = TextStyle(
      color: Colors.blue,
      fontSize: 20,
    );
    var textSpan = TextSpan(
      text: 'G',
      style: textStyle,
    );
    var textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 20,
    );
    textPainter.paint(canvas, this.offset);
  }

  void drawLabel(Canvas canvas){
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.blue //いる
      ..strokeWidth = 5.0 //いる
      ..style = PaintingStyle.stroke;
    Rect r = new Rect.fromLTWH(this.offset.dx, this.offset.dy, 30, 5);
    canvas.drawRect(r, paint);
  }
}

class ImagePainter extends CustomPainter{
  ui.Image image;
  File imageFile;
  List<Mark> marks;
  Size mediaSize;
  ImagePainter(this.image, this.marks, this.imageFile);
  ImagePainter.ms(this.image, this.marks, this.imageFile, this.mediaSize);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    this.mediaSize = size;
    drawToCanvas(canvas);
  }

  void drawToCanvas(ui.Canvas canvas){
    if(this.image != null){
      var paint = new Paint();
      canvas.save();
      double scale = min(mediaSize.width/this.image.width.toDouble(), mediaSize.height/this.image.height.toDouble());
      canvas.scale(scale, scale);

      double pos = (mediaSize.height- this.image.height*scale);
      canvas.drawImage(this.image, Offset(0,pos), paint);
      canvas.restore();
    }

    canvas.save();
    for(Mark mark in marks){
      mark.drawToCanvas(canvas);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  void saveImage() async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas canvas = Canvas(recorder);
    drawToCanvas(canvas);
    ui.Picture picture = recorder.endRecording();
    ui.Image img = await picture.toImage(mediaSize.width.toInt(), mediaSize.height.toInt());
    final ByteData bytedata = await img.toByteData(format: ui.ImageByteFormat.png);
    int epoch = new DateTime.now().millisecondsSinceEpoch;
    final file = new File(imageFile.parent.path + '/' + epoch.toString() + '.png');
    file.writeAsBytes(bytedata.buffer.asUint8List());
    print(file.path);
  }

  // カメラか持っている画像を選択させる
  


}