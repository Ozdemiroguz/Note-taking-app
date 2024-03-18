import 'package:firstvisual/screens/homeScreen/home_screen.dart';
import 'package:firstvisual/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FeaturePage extends StatefulWidget {
  @override
  _FeaturePageState createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  final _pageController = PageController();

  final _features = [
    {
      'title': 'Free Note Taking',
      'description':
          'Users can freely take notes to record their thoughts, ideas, and tasks.',
      'assets': 'animations/getstared3.json',
    },
    {
      'title': 'Task List',
      'description':
          'Users can create a task list to keep track of their tasks and to-dos.',
      'assets': 'animations/getstared2.json',
    },
    {
      'title': 'Drawing',
      'description':
          'Users can draw and take notes on the same screen to make their notes more visual.',
      'assets': 'animations/getstarted3.json',
    },
    {
      'title': 'Image',
      'description':
          'Users can add images to their notes to make their notes more visual.',
      'assets': 'animations/image.json',
    },
    {
      'title': 'Editing',
      'description':
          'Users can edit their notes, tasks, and drawings to make them more organized.',
      'assets': 'animations/edit.json',
    },
    {
      'title': 'Get Start!!',
      'description': 'Start using Note It now!',
      'assets': 'animations/rabbit.json',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Welcome to Note It!', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.softBack,
      ),
      backgroundColor: AppColors.softBack,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _features.length,
              itemBuilder: (context, index) {
                if (index == _features.length - 1) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          _features[index]['assets']!,
                          height: 300,
                          width: 300,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            //homeScreen.dart a yönlendirme yapılacak
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Get Start!!',
                            style: TextStyle(color: AppColors.softBack),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      _features[index]['assets']!,
                      height: 300,
                      width: 300,
                    ),
                    Text(
                      _features[index]['title']!,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _features[index]['description']!,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
                // Sayfa içeriği
              },
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: _features.length,
            effect: ExpandingDotsEffect(
              activeDotColor: Colors.white,
              dotColor: Colors.white,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
