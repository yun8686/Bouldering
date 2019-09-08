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

  GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    mediasize = MediaQuery.of(context).size;
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Camera App!"),
//      ),
      body: SafeArea(
        child: GestureDetector(
          onTapUp: _onTapUp,
          onLongPressMoveUpdate: _onPointerMove,
          onScaleUpdate: _onScaleUpdate,
          onScaleEnd: _onScaleEnd,
          onScaleStart: _onScaleStart,
          child: Container(
            child: CustomPaint(
              key: _canvasKey,
              painter: ImagePainter(targetimage, marks, imageFile),
            ),
            color: Colors.grey,
            height: mediasize.height,
            width: mediasize.width,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
      ),
    );
  }

  void getImage() async{
    if(this.imageFile == null){
      File file = await ImagePicker.pickImage(source: ImageSource.camera);
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

  void _onTapUp(TapUpDetails details) {
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    nowMark = new Mark(referenceBox.globalToLocal(details.globalPosition), 20);
    print("opTapUp");
    setState(() {
      marks.add(nowMark);
    });
  }
  void _onPointerMove(LongPressMoveUpdateDetails details) {
    RenderBox referenceBox = _canvasKey.currentContext.findRenderObject();
    setState(() {
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
  Mark(this.offset, this.scale);

  void drawToCanvas(Canvas canvas){
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.blue
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(this.offset, this.scale, paint);
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


}