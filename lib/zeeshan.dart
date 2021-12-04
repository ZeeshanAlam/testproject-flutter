import 'package:flutter/material.dart';

class Zeeshan extends StatefulWidget {
  const Zeeshan({Key? key}) : super(key: key);

  @override
  _ZeeshanState createState() => _ZeeshanState();
}

class _ZeeshanState extends State<Zeeshan> {
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);

    return Scaffold(
      body: Container(
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 4,
          itemBuilder: (_,int index){
            return _playView(context, index);
          },
          controller: controller,
          onPageChanged: _onPageViewChange,
        ),
      ),
    );
  }

  _onPageViewChange(int page) {
    debugPrint("Current Page: " + page.toString());
    int previousPage = page;
    if(page != 0) previousPage--;
    else previousPage = 2;
    debugPrint("Previous page: $previousPage");
  }

  List<Color> colors = [Colors.blue, Colors.red, Colors.yellow, Colors.green];

  Widget _playView(BuildContext context, int index){
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: colors[index],
      );
  }
}