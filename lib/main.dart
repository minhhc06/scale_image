import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matrix_project/matrix_gesture_detector.dart';
import 'package:matrix_project/shared/consts/shared_icons.dart';
import 'package:matrix_project/shared/consts/shared_images.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  Alignment focalPoint = Alignment.center;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: MatrixGestureDetector(
          onMatrixUpdate: (m, tm, sm, rm) {
            // if (widget.onChanged == null) return;
            notifier.value =
                MatrixGestureDetector.compose(notifier.value, tm, sm, rm);
            // widget.onChanged?.call(notifier.value);
            // print('-- ${notifier.value.getTranslation()}'); // position
          },
          // focalPointAlignment: focalPoint,
          child: AnimatedBuilder(
            animation: notifier,
            builder: (ctx, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                makeTransform(ctx, child),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget makeTransform(BuildContext context, Widget? child) {
    return Transform(
      transform: notifier.value,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          alignment: focalPoint,
          child: child,
        ),
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease,
        child: GestureDetector(
          onTap: () {},
          // child: Container(
          //   color: Colors.red,
          //   height: 100,
          //   width: 100,
          // ),
          // child: SvgPicture.asset(
          //   SharedIcons.iconShareLink,
          //   width: 100,
          //   height: 100,
          // ),
          child: Image.asset(
            SharedImages.imageBook,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
