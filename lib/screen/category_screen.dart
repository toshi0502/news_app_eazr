import 'package:flutter/material.dart';
import 'package:news_app_eazr/provider/news_provider.dart';
import 'package:news_app_eazr/screen/artical_screen.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  CategoryScreen({required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      newsProvider.fetchArticles(widget.category, isRefresh: true);
    });

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    //     if (newsProvider.hasMoreArticles && !newsProvider.isLoading) {
    //       newsProvider.fetchArticles(widget.category);
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category} News',
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (ctx, newsProvider, _) {
          if (newsProvider.isLoading && newsProvider.articles.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (newsProvider.errorMessage.isNotEmpty) {
            return Center(child: Text(newsProvider.errorMessage));
          }

          return RefreshIndicator(
            onRefresh: () =>
                newsProvider.fetchArticles(widget.category, isRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: newsProvider.articles.length +
                  (newsProvider.hasMoreArticles ? 1 : 0),
              itemBuilder: (ctx, index) {
                if (index == newsProvider.articles.length) {
                  return Center(child: CircularProgressIndicator());
                }

                final article = newsProvider.articles[index];
                return Container(
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
                          builder: (ctx) => ArticleScreen(article: article),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        article.urlToImage.isNotEmpty
                            ? Image.network(
                                article.urlToImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
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
                            : Text('Sorry, this Artical has been Removed'),
                        SizedBox(height: 10),
                        article.urlToImage.isNotEmpty
                            ? Text(
                                article.title,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        SizedBox(height: 5),
                        article.urlToImage.isNotEmpty
                            ? Text(
                                article.description,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container()
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    if (currentScroll >= maxScroll &&
        !newsProvider.isLoading &&
        newsProvider.hasMoreArticles) {
      newsProvider.fetchArticles(widget.category);
    }
  }

  Future<void> _refreshData(BuildContext context) async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    await newsProvider.fetchArticles(widget.category, isRefresh: true);
  }

  Widget _buildLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  int _calculateListItemCount(NewsProvider newsProvider) {
    return newsProvider.articles.length +
        (newsProvider.hasMoreArticles ? 1 : 0);
  }
}
