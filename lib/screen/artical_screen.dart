import 'package:flutter/material.dart';
import 'package:news_app_eazr/model/news_model.dart';
import 'package:news_app_eazr/screen/full_artical_screen.dart';

class ArticleScreen extends StatelessWidget {
  final NewsArticle article;

  ArticleScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              article.urlToImage.isNotEmpty
                  ? Image.network(
                      article.urlToImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: orientation == Orientation.portrait
                          ? screenSize.height * 0.3
                          : screenSize.height * 0.5,
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
                    )
                  : Text('Article Removed'),
              SizedBox(height: 10),
              Text(article.description,
                  style: TextStyle(fontSize: 18, color: Colors.blue)),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Return to Home Page'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
