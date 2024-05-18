import 'package:flutter/material.dart';
import 'package:news_app_eazr/screen/category_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = [
    'Business',
    'entertainment',
    'General',
    'Health',
    'Science',
    'Sports',
    'Technology'
  ];

  final Map<String, String> categoryImages = {
    'Business': 'assets/images/business.jpg',
    'entertainment': 'assets/images/entertainment.jpg',
    'General': 'assets/images/genral.jpg',
    'Health': 'assets/images/health.jpg',
    'Science': 'assets/images/science.jpg',
    'Sports': 'assets/images/sports.jpg',
    'Technology': 'assets/images/tech.jpg',
  };

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Categories',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          String category = categories[index];
          String imageUrl =
              categoryImages[category] ?? 'assets/images/Business.jpg';
          double containerHeight = orientation == Orientation.portrait
              ? screenSize.height * 0.25
              : screenSize.height * 0.5;
          return Container(
              height: containerHeight,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5), // Border color
                  width: 1, // Border width
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => CategoryScreen(category: category),
                    ),
                  );
                },
                child: Row(children: [
                  // Display the image for the category
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            width: double.infinity,
                            height: 150,
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey[400],
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Display the category name
                  Container(
                      width: 100,
                      child: Text(category,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 33, 75, 243))))
                ]),
              ));
        },
      ),
    );
  }
}
