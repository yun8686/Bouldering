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
      home: new MyImagePage(context:context),
    );
  }
}

class MyImagePage extends StatefulWidget{
  BuildContext context;
  MyImagePage({this.context});

  @override
  _MyImagePageState createState() => _MyImagePageState(context: this.context);
}

class _MyImagePageState extends State<MyImagePage>{
  BuildContext context;
    _MyImagePageState({this.context});
  ui.Image targetimage;
  File imageFile;
  Size mediasize;
  //　選択フラグ
  var pressAttention = new List.generate(4, (i)=>false);
  var selectMark = '';
  // 画像が入っていない場合はtrueでカメラアイコンを表示
  var _canShowCameraIcon = true;

  GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
    title: Text('Demo'),
    );
    double appBarHeight = appBar.preferredSize.height;
    print(appBarHeight);
    mediasize = MediaQuery.of(context).size;
    return Scaffold(
      body: 
      Stack(
        children: <Widget>[
          SafeArea(
          child: GestureDetector(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppBar(
                  title: const Text('課題作成'),
                  backgroundColor: Colors.grey,
                  centerTitle: true,
                ),
                Expanded(
                  // 写真表示箇所
                  child: GestureDetector(
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
                        // height: mediasize.height - appBarHeight - 64,
                        width: mediasize.width,
                      ),
                    ),
                  ),
                ),
                // フッター箇所
                Container(
                  height: 64,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey,
                    ),
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 戻るアイコン
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: IconButton(
                            color: Colors.grey,
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () => Navigator.pop(this.context),
                          ),
                        ),
                        // 余白の分
                        SizedBox(
                          height: 40,
                          width: mediasize.width * 0.4,
                        ),
                        // スタンプを開くアイコン
                        SizedBox(
                          height: 40,
                          width: mediasize.width * 0.2,
                          child: IconButton(
                            color: Colors.grey,
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.white),
                            onPressed: () => print('delete'),//_showModalIcon(),
                          ),
                        ),
                        // 完了するボタン
                        SizedBox(
                          height: 40,
                          width: mediasize.width * 0.2,
                          child: IconButton(
                            color: Colors.grey,
                            icon: Icon(
                              Icons.done,
                              color: Colors.white),
                            onPressed: () => _onSave,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // カメラアイコン
        Positioned(
          left: mediasize.width * 0.5 - 32,
          top: mediasize.height * 0.5 - 30,
          child: _canShowCameraIcon
            ? IconButton(
            color: Colors.grey,
            icon: Icon(
              Icons.camera_alt,
              color: Colors.black,
              size: 50
            ),
            onPressed: () => _showModalSelectImage(),
          ) : SizedBox(),
        ),
        // スタンプ設定箇所
        Positioned.fill(
          top: mediasize.height - 174,
          child:Row(
            children: <Widget>[
              // 写真追加
              Expanded(
                child: RawMaterialButton(
                  child: Icon(
                    Icons.replay,
                    color: Colors.black,
                    size: 30
                  ),
                  shape: new CircleBorder(),
                  fillColor: Colors.white,
                  onPressed: () => _onLastRemove(),
                ),
              ),
              Expanded(
                child: Center(
                  child:RawMaterialButton(
                    child: Text("S",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: pressAttention[0] ?  Colors.blue: Color(0xFF303030),
                        )
                    ),
                    shape: new CircleBorder(),
                    fillColor: Colors.white,
                    onPressed:() => setState(() => selectArtIcon(0,'start')),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child:RawMaterialButton(
                    child: Text("G",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: pressAttention[1] ? Colors.blue: Color(0xFF303030),
                        )
                    ),
                  shape: new CircleBorder(),
                  fillColor: Colors.white,
                  onPressed:() => setState(() => selectArtIcon(1,'gole')),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: RawMaterialButton(
                    child: RotationTransition(
                      child: Icon(
                        Icons.radio_button_unchecked,
                        color: pressAttention[2] ? Colors.blue: Color(0xFF303030),
                      ),
                      turns: new AlwaysStoppedAnimation(135 / 360),
                    ),
                    shape: new CircleBorder(),
                    fillColor: Colors.white,
                    onPressed:() => setState(() => selectArtIcon(2,'maru')),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: RawMaterialButton(
                    child: RotationTransition(
                      child: Icon(
                        Icons.label,
                        color: pressAttention[3] ? Colors.blue: Color(0xFF303030),
                      ),
                      turns: new AlwaysStoppedAnimation(135 / 360),
                    ),
                    shape: new CircleBorder(),
                    fillColor: Colors.white,
                    onPressed:() => setState(() => selectArtIcon(3,'label')),
                  ),
                ),
              ),
            ],
          )
        ),
      ]),
    );
  }
  
  void selectArtIcon(number,name){
    for(var i = 0; i < pressAttention.length; i++) {
      pressAttention[i] = false;
    }
    pressAttention[number] = true;
    selectMark = name;
  }

  void _showModalSelectImage() {
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
                getCamera().then((v){setState(() {
                  _canShowCameraIcon = false; 
                });});
              },
            ),
            ListTile(
              leading: Icon(Icons.filter),
              title: Text('画像'),
              onTap: () {
                Navigator.pop(context);
                getImage().then((v){setState(() {
                  _canShowCameraIcon = false; 
                });});
              },
            ),
          ],
        );
      },
    );
  }

  void _showModalIcon() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // 写真追加
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(this.context),
            ),
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
        );
      },
    );
  }

  Future<void> getCamera() async{
    if(this.imageFile == null){
      File file = await ImagePicker.pickImage(source: ImageSource.camera);
      this.imageFile = file;
      loadImage(file);
    }else{
      ImagePainter.ms(targetimage, marks, imageFile, mediasize).saveImage();
    }
  }
  Future<void> getImage() async{
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
  }

  // ロングタップを検知して、アイコンを移動できるフラグを変更
  void _onLongPressStart(LongPressStartDetails details){
    if(marks.length==0) return;
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    var touchPostion = referenceBox.globalToLocal(details.globalPosition);
    // タップした箇所にアイコンがあるか判定
    Iterable inReverse = marks.reversed;
    var marksInReverse = inReverse.toList();
    nowMark = marksInReverse.lastWhere( (icon) =>
      sqrt(pow((icon.offset.dx - touchPostion.dx).abs().toDouble(), 2) + pow((icon.offset.dy - touchPostion.dy).abs().toDouble(), 2)) < 20
      ,orElse: () => null
    );
    if(nowMark == null){
      return;
    }
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
    if(longPressFlag==false) return;
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    var touchPostion = referenceBox.globalToLocal(details.globalPosition);
    setState(() {
        // 要素を移動させる処理
        nowMark.offset = touchPostion;
    });
  }

  // 一つ前に戻る処理
  void _onLastRemove(){
    setState(() {
      if(marks.length != 0){
        marks.removeLast();
      }
    });
  }

  // 画像保存処理
  void _onSave(TapUpDetails details){
    // CanvasElement canvas = document.query('#canvas');
    // String dataUrl = canvas.toDataUrl();
    // var picture = recorder.endRecording();
    // var image =picture.toImage(lastSize.width.round(), lastSize.height.round());
    // ByteData data = await image.toByteData(format: ui.ImageByteFormat.png);
    // data.buffer.asUint8List();
  }

  // アイコンの大きさを変更する処理
  double basescale = 1;
  void _onScaleUpdate(ScaleUpdateDetails details) {
    // List<Mark> marks;
    print('List<Mark> marks');
    print(marks);
    print(marks.length > 0);
    if(marks.length > 0){
      setState(() {
        nowMark.scale = details.scale*basescale;
        print(nowMark);
        // nowMark.fontSize = details.fontSize
      });
    }
    else{
      setState(() {
        // ここに画像を入れる
        print(targetimage);
        print(this.imageFile);
        // Img.copyResize(targetimage, 800);
      });
    }
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
      fontSize: 2 * this.scale,
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
      fontSize: 2 * this.scale,
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
    var icon = Icons.label;
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      fontFamily: icon.fontFamily,
      fontSize: 2 * this.scale,
    ))
      ..pushStyle(new ui.TextStyle(color: Colors.blue))
      ..addText(String.fromCharCode(icon.codePoint));
    var para = builder.build();
    para.layout(const ui.ParagraphConstraints(width: 60));
    canvas.drawParagraph(para, this.offset);
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