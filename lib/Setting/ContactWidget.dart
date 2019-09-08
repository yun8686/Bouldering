
import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  ContactWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お問い合わせ'),
      ),
    );
  }
}