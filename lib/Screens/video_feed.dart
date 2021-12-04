import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';


class VideoFeed extends StatefulWidget {
  const VideoFeed({Key? key}) : super(key: key);
  @override
  _VideoFeedState createState() => _VideoFeedState();
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class _VideoFeedState extends State<VideoFeed> {
  List videoInfo = [];
  int videoLength=0;
  VideoPlayerController? _controller;

  Future<void> _initData() async {
    // Get docs from collection reference
    CollectionReference TrendingVideos = FirebaseFirestore.instance.collection('TrendingVideos');
    QuerySnapshot querySnapshot = await TrendingVideos.get();

    // Get data from docs and convert map to List
    videoInfo = querySnapshot.docs.map((doc) => doc.data()).toList();
    //videoLength=allData.length;
    print(videoInfo);
    setState(() {
      build(context);
      _onTapVideo(0);
    });
  }

  @override
  void initState(){
    super.initState();
    _initData();
    //_onTapVideo(-1);
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);

    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Container(
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: videoInfo.length,
          itemBuilder: (_,int index){
            return _pageView(context, index);
          },
          controller: controller,
          onPageChanged: _onPageViewChange,
        ),
      ),
    );
  }

  Widget _playView(BuildContext context){
    final vcontroller = _controller;
    if(vcontroller!=null&&vcontroller.value.isInitialized){
    return Container(
        height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height/3),
        width: MediaQuery.of(context).size.width - 20,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.zero,
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0.0,2.0),
              blurRadius: 5.0,
              spreadRadius: 3.5
            ),
          ],
        ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
            topRight: Radius.zero,
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0)),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 100,
                height: 100,
                child: VideoPlayer(vcontroller),
              ),
            ),
          )


          // width: MediaQuery.of(context).size.width,
      );
    }else{
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
          child:const Text("Being Initialized please wait",
          textAlign: TextAlign.center,),

      );
    }

  }

  _onPageViewChange(int page) {
    debugPrint("Current Page: " + page.toString());
    int previousPage = page;
    _onTapVideo(page);
    if(page != 0) previousPage--;
    else previousPage = 2;
    debugPrint("Previous page: $previousPage");
  }

  List<Color> colors = [Colors.blue, Colors.red, Colors.yellow, Colors.green];

  Widget _pageView(BuildContext context, int index){
    return Scaffold(
      backgroundColor:  const Color.fromRGBO(200, 200, 255, 0.8),
      body: Center(
        child: Column(
          children:  [
            /*const SizedBox(
              height: 10,
              width: 100,
            ),*/
            _controller != null?
            _playView(context) : Container(),
           Expanded(
             child: Column(
               children: [
                 const SizedBox(height: 25),

                 Container(
                 height: 100,
                 width: (MediaQuery.of(context).size.width-0),
                 margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                 decoration: const BoxDecoration(
                   color: Color.fromRGBO(66, 103, 178, 0.8),
                   borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(10),
                       topRight: Radius.circular(10),
                       bottomLeft: Radius.circular(10.0),
                       bottomRight: Radius.circular(10.0)),
                   boxShadow: [
                     BoxShadow(
                         color: Colors.black45,
                         offset: Offset(0.0,2.0),
                         blurRadius: 5.0,
                         spreadRadius: 3.5
                     ),
                   ],
                 ),
                   child:  Align(
                     alignment: Alignment.center,
                     child: Text(videoInfo[index]['Hash'],
                       textAlign: TextAlign.center,
                       style: const TextStyle(
                           fontSize: 25,
                           color: Colors.white,
                           fontWeight: FontWeight.w700,
                           fontStyle: FontStyle.normal,
                           letterSpacing: 2,
                           wordSpacing: 20,
                           shadows: [
                           Shadow(color: Colors.blueAccent, offset: Offset(2,1), blurRadius:10)
                         ]
                       ),
                     ),
                   ),
               ),
             ]
             ),

           ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 100,
                      width: (MediaQuery.of(context).size.width-40)/2,
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(66, 103, 178, 0.8),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0.0,2.0),
                              blurRadius: 5.0,
                              spreadRadius: 3.5
                          ),
                        ],
                      ),
                      child:  Align(
                        alignment: Alignment.center,
                        child: Text(videoInfo[index]['Filter'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 2,
                              wordSpacing: 20,
                              shadows: [
                                Shadow(color: Colors.blueAccent, offset: Offset(2,1), blurRadius:10)
                              ]
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: (MediaQuery.of(context).size.width-40)/2,
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(66, 103, 178, 0.8),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0.0,2.0),
                              blurRadius: 5.0,
                              spreadRadius: 3.5
                          ),
                        ],
                      ),
                      child:  Align(
                        alignment: Alignment.center,
                        child: Text(videoInfo[index]['Music'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 2,
                              wordSpacing: 20,
                              shadows: [
                                Shadow(color: Colors.blueAccent, offset: Offset(2,1), blurRadius:10)
                              ]
                          ),
                        ),
                      ),
                    ),

                  ]
              ),
            ),


            // Container()
          ],
        ),

      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () => {
          _onTapVideo(index),
        },

      ),*/
    );
  }

  _onTapVideo (int index){
    final controller = VideoPlayerController.network(videoInfo[index]['Video']);
    _controller = controller;
    setState(() {

    });
    controller..initialize().then((_){
      controller.play();
      setState(() {
      });
    });
  }
}


