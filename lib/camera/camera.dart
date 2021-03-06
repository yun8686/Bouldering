import 'dart:io';
import 'dart:math';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';

class CameraWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Camera App",
      theme: new ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
      ),
      home: new MyImagePage(context: context),
    );
  }
}

class MyImagePage extends StatefulWidget {
  BuildContext context;
  // onScaleStart、onScaleUpdate、onScaleEnd
  // 上記のイベントと競合するため、イベントを止めれるように変数でON/OFFを管理出来るように設定
  var onPanStart = true;
  var onPanUpdate = true;
  var onPanEnd = true;
  MyImagePage({this.context});

  @override
  _MyImagePageState createState() => _MyImagePageState(context: this.context);
}

class _MyImagePageState extends State<MyImagePage> {
  BuildContext context;
  _MyImagePageState({this.context});
  ui.Image targetimage;
  File imageFile;
  Size mediasize;
  //　選択フラグ
  var pressAttention = new List.generate(4, (i) => false);
  var selectMark = '';
  // 画像が入っていない場合はtrueでカメラアイコンを表示
  var _canShowCameraIcon = true;
  // テストコード
  int radius = 250;
  // 拡大/縮小
  double _scaleValue = 20;
  //　回転
  double _rotateValue = 0;
  GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    mediasize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: <Widget>[
        SafeArea(
          child: GestureDetector(
            child: Column(
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
                    onPanStart: widget.onPanStart == null
                        ? null
                        : (DragStartDetails details) {
                            _onPanStart(details);
                          },
                    onPanUpdate: widget.onPanUpdate == null
                        ? null
                        : (DragUpdateDetails details) {
                            _onPointerMove(details);
                          },
                    onPanEnd: widget.onPanEnd == null
                        ? null
                        : (DragEndDetails details) {
                            _onPanEnd(details);
                          },
                    child: SafeArea(
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
                Container(
                  color: Colors.grey,
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.zoom_in,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Slider(
                        min: 4,
                        max: 180,
                        value: _scaleValue,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.blueAccent,
                        onChanged: _changeScale,
                      ),
                    ),
                  ]),
                ),
                Container(
                  color: Colors.grey,
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.loop,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Slider(
                        min: -180,
                        max: 180,
                        value: _rotateValue,
                        activeColor: Colors.red,
                        inactiveColor: Colors.blueAccent,
                        onChanged: _changeRotate,
                      ),
                    ),
                  ]),
                ),
                // フッター箇所
                Container(
                  height: 64,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Row(
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
                        // 画像を削除するボタン
                        SizedBox(
                          height: 40,
                          width: mediasize.width * 0.2,
                          child: IconButton(
                            color: Colors.grey,
                            icon:
                                Icon(Icons.delete_forever, color: Colors.white),
                            onPressed: () => _showModalDelete(),
                          ),
                        ),
                        // 完了するボタン
                        SizedBox(
                          height: 40,
                          width: mediasize.width * 0.2,
                          child: IconButton(
                            color: Colors.grey,
                            icon: Icon(Icons.done, color: Colors.white),
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
                  icon: Icon(Icons.camera_alt, color: Colors.black, size: 50),
                  onPressed: () => _showModalSelectImage(),
                )
              : SizedBox(),
        ),
        // スタンプ設定箇所
        Positioned.fill(
            top: mediasize.height - 174 * 2,
            child: Row(
              children: <Widget>[
                // 写真追加
                Expanded(
                  child: RawMaterialButton(
                    child: Icon(Icons.replay, color: Colors.black, size: 30),
                    shape: new CircleBorder(),
                    fillColor: Colors.white,
                    onPressed: () => _onLastRemove(),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: RawMaterialButton(
                      child: Text("S",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: pressAttention[0]
                                ? Colors.blue
                                : Color(0xFF303030),
                          )),
                      shape: new CircleBorder(),
                      fillColor: Colors.white,
                      onPressed: () =>
                          setState(() => selectArtIcon(0, 'start')),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: RawMaterialButton(
                      child: Text("G",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: pressAttention[1]
                                ? Colors.blue
                                : Color(0xFF303030),
                          )),
                      shape: new CircleBorder(),
                      fillColor: Colors.white,
                      onPressed: () => setState(() => selectArtIcon(1, 'gole')),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: RawMaterialButton(
                      child: RotationTransition(
                        child: Icon(
                          Icons.radio_button_unchecked,
                          color: pressAttention[2]
                              ? Colors.blue
                              : Color(0xFF303030),
                        ),
                        turns: new AlwaysStoppedAnimation(135 / 360),
                      ),
                      shape: new CircleBorder(),
                      fillColor: Colors.white,
                      onPressed: () => setState(() => selectArtIcon(2, 'maru')),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: RawMaterialButton(
                      child: RotationTransition(
                        child: Icon(
                          Icons.label,
                          color: pressAttention[3]
                              ? Colors.blue
                              : Color(0xFF303030),
                        ),
                        turns: new AlwaysStoppedAnimation(135 / 360),
                      ),
                      shape: new CircleBorder(),
                      fillColor: Colors.white,
                      onPressed: () =>
                          setState(() => selectArtIcon(3, 'label')),
                    ),
                  ),
                ),
              ],
            )),
      ]),
    );
  }

  void selectArtIcon(number, name) {
    for (var i = 0; i < pressAttention.length; i++) {
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
                getCamera().then((v) {
                  setState(() {
                    _canShowCameraIcon = false;
                  });
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.filter),
              title: Text('画像'),
              onTap: () {
                Navigator.pop(context);
                getImage().then((v) {
                  setState(() {
                    _canShowCameraIcon = false;
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showModalDelete() {
    // 削除の確認モーダル
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("本当に画像を削除してよいでしょうか？"),
            Row(children: <Widget>[
              Expanded(
                child: Center(
                  child: RaisedButton(
                    child: Text("いいえ"),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: RaisedButton(
                    child: Text("はい"),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ),
            ]),
          ],
        );
      },
    );
  }

  Future<void> getCamera() async {
    if (this.imageFile == null) {
      File file = await ImagePicker.pickImage(source: ImageSource.camera);
      this.imageFile = file;
      loadImage(file);
    } else {
      ImagePainter.ms(targetimage, marks, imageFile, mediasize).saveImage();
    }
  }

  Future<void> getImage() async {
    if (this.imageFile == null) {
      File file = await ImagePicker.pickImage(source: ImageSource.gallery);
      this.imageFile = file;
      loadImage(file);
    } else {
      ImagePainter.ms(targetimage, marks, imageFile, mediasize).saveImage();
    }
  }

  void loadImage(File image) async {
    List<int> byts = await image.readAsBytes();
    Uint8List u8lst = Uint8List.fromList(byts);
    ui.instantiateImageCodec(u8lst).then((codec) {
      codec.getNextFrame().then((frameInfo) {
        setState(() {
          targetimage = frameInfo.image;
          marks = List<Mark>();
        });
      });
    });
  }

  Mark nowMark = null;
  List<Mark> marks = new List<Mark>();
  var onPanUpdateFlag = false;

  // タップが離れたときの処理
  void _onTapUp(TapUpDetails details) {
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    // nowMark(Offset,size,mark-kind,rotation)
    nowMark = new Mark(
        // アイコンの初期値分表示箇所をずらす処理
        referenceBox.globalToLocal(Offset(
            details.globalPosition.dx - 20, details.globalPosition.dy - 20)),
        20,
        selectMark,
        0);
    setState(() {
      marks.add(nowMark);
    });
  }

  // アイコンを移動できるフラグを変更
  void _onPanStart(DragStartDetails details) {
    if (marks.length == 0) return;
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    var touchPostion = referenceBox.globalToLocal(details.globalPosition);
    // タップした箇所にアイコンがあるか判定
    Iterable inReverse = marks.reversed;
    var marksInReverse = inReverse.toList();
    nowMark = marksInReverse.lastWhere(
        (icon) =>
            sqrt(pow(
                    (icon.offset.dx + nowMark.scale / 2 - touchPostion.dx)
                        .abs()
                        .toDouble(),
                    2) +
                pow(
                    (icon.offset.dy + nowMark.scale / 2 - touchPostion.dy)
                        .abs()
                        .toDouble(),
                    2)) <
            icon.scale + 40,
        orElse: () => null);
    if (nowMark == null) {
      return;
    }
    setState(() {
      onPanUpdateFlag = true;
      //対象のアイコンがある��合は大きくする処理
    });
  }

  // Panイベント中に移動させる処理
  void _onPointerMove(DragUpdateDetails details) {
    if (onPanUpdateFlag == false) return;
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    var touchPostion;
    if (nowMark.selectMark == 'maru') {
      touchPostion = referenceBox.globalToLocal(
          Offset(details.globalPosition.dx, details.globalPosition.dy));
    } else {
      touchPostion = referenceBox.globalToLocal(Offset(
          details.globalPosition.dx - nowMark.scale,
          details.globalPosition.dy - nowMark.scale));
    }

    setState(() {
      //選択したアイコンを動かす
      nowMark.offset = touchPostion;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      onPanUpdateFlag = false;
    });
    if (nowMark == null && marks.length > 0) {
      nowMark = marks[marks.length - 1];
    }
  }

  // 拡大縮小
  void _changeScale(double e) {
    print(nowMark);
    if (nowMark != null && marks.length > 0) {
      setState(() {
        nowMark.scale = e;
        _scaleValue = e;
      });
    }
  }

  // 回転処理
  void _changeRotate(double e) {
    print(nowMark);
    if (nowMark != null && marks.length > 0) {
      setState(() {
        nowMark.rotation = e;
        _rotateValue = e;
      });
    }
  }

  // 一つ前に戻る削除処理
  void _onLastRemove() {
    setState(() {
      if (marks.length != 0) {
        marks.removeLast();
      }
    });
  }

  // 画像保存処理
  void _onSave(TapUpDetails details) {
    // CanvasElement canvas = document.query('#canvas');
    // String dataUrl = canvas.toDataUrl();
    // var picture = recorder.endRecording();
    // var image =picture.toImage(lastSize.width.round(), lastSize.height.round());
    // ByteData data = await image.toByteData(format: ui.ImageByteFormat.png);
    // data.buffer.asUint8List();
  }

  // PanイベントとScaleイベントを両立させるために対応
  void _changePanEvent() {
    widget.onPanUpdate = true;
    widget.onPanStart = true;
    widget.onPanEnd = true;
  }

  void _changeScaleEvent() {
    widget.onPanUpdate = null;
    widget.onPanStart = null;
    widget.onPanEnd = null;
  }
}

Size canvasSize;

class Mark {
  Offset offset;
  double scale;
  String selectMark;
  double rotation;

  Mark(this.offset, this.scale, this.selectMark, this.rotation);

  void drawToCanvas(Canvas canvas) {
    if (this.selectMark == 'maru') {
      printMaru(canvas);
    } else if (this.selectMark == 'start') {
      drawS(canvas);
    } else if (this.selectMark == 'gole') {
      drawG(canvas);
    } else if (this.selectMark == 'label') {
      drawLabel(canvas);
    }
  }

  void printMaru(Canvas canvas) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.blue //いる
      ..strokeWidth = 5.0 //いる
      ..style = PaintingStyle.stroke;
    print(this.offset);
    canvas.drawCircle(
        Offset(this.offset.dx + 20, this.offset.dy + 20), this.scale, paint);
  }

  void drawS(Canvas canvas) {
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

  void drawG(Canvas canvas) {
    var textSpan = TextSpan(
      text: 'G',
      style: TextStyle(
        color: Colors.blue,
        fontSize: 2 * this.scale,
      ),
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

  void drawLabel(Canvas canvas) {
    var icon = Icons.label;
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      fontFamily: icon.fontFamily,
      fontSize: 2 * this.scale,
    ))
      ..pushStyle(new ui.TextStyle(color: Colors.blue))
      ..addText(String.fromCharCode(icon.codePoint));
    var para = builder.build();
    para.layout(const ui.ParagraphConstraints(width: 60));

    // rotate the canvas
    canvas.save();
    var rotateWidth = (canvasSize.width) / 2 -
        (canvasSize.width / 2 - this.offset.dx) +
        para.width / 2;
    var rotateHeight = (canvasSize.height) / 2 -
        (canvasSize.height / 2 - this.offset.dy) +
        para.height / 2;

    canvas.translate(rotateWidth, rotateHeight);
    final degrees = this.rotation;
    final radians = degrees * math.pi / 180;
    canvas.rotate(radians);
    canvas.translate(-1 * rotateWidth, -1 * rotateHeight);
    canvas.drawParagraph(para, this.offset);
    canvas.restore();
  }
}

class ImagePainter extends CustomPainter {
  ui.Image image;
  File imageFile;
  List<Mark> marks;
  Size mediaSize;
  ImagePainter(this.image, this.marks, this.imageFile);
  ImagePainter.ms(this.image, this.marks, this.imageFile, this.mediaSize);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    this.mediaSize = size;
    canvasSize = this.mediaSize;
    drawToCanvas(canvas);
  }

  void drawToCanvas(ui.Canvas canvas) {
    if (this.image != null) {
      var paint = new Paint();
      canvas.save();
      double scale = min(mediaSize.width / this.image.width.toDouble(),
          mediaSize.height / this.image.height.toDouble());
      canvas.scale(scale, scale);

      double pos = (mediaSize.height - this.image.height * scale);
      canvas.drawImage(this.image, Offset(0, pos), paint);
      canvas.restore();
    }

    canvas.save();
    for (Mark mark in marks) {
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
    ui.Image img = await picture.toImage(
        mediaSize.width.toInt(), mediaSize.height.toInt());
    final ByteData bytedata =
        await img.toByteData(format: ui.ImageByteFormat.png);
    int epoch = new DateTime.now().millisecondsSinceEpoch;
    final file =
        new File(imageFile.parent.path + '/' + epoch.toString() + '.png');
    file.writeAsBytes(bytedata.buffer.asUint8List());
    print(file.path);
  }

  // カメラか持っている画像を選択させる

}
