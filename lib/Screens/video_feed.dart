import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';


class VideoFeed extends StatefulWidget {
  const VideoFeed({Key? key}) : super(key: key);
  @override
  _VideoFeedState createState() => _VideoFeedState();
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: VideoPlayer(vcontroller),
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
    if(page != 0) previousPage--;
    else previousPage = 2;
    debugPrint("Previous page: $previousPage");
  }

  List<Color> colors = [Colors.blue, Colors.red, Colors.yellow, Colors.green];

  Widget _pageView(BuildContext context, int index){
    return Scaffold(
      body: Center(
        child: Column(
          children:  [
            _controller != null?
            _playView(context) : Container(
            )
           // Container()
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () => {
          _onTapVideo(index),
        },
        
      ),
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


