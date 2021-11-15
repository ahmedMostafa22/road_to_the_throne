import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, this.loadingMessage = 'loading...', this.size = 25})
      : super(key: key);

  final String loadingMessage;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SpinKitFoldingCube(color: Theme.of(context).primaryColor, size: size),
      const SizedBox(height: 16),
      Text(
        loadingMessage,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )
    ]);
  }
}
