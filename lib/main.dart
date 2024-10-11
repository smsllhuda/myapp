import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/data/newsmodel.dart';

// Model classes (already defined)


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Welcome>? futureWelcome;

  @override
  void initState() {
    super.initState();
    futureWelcome = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Center(
  child: FutureBuilder<Welcome>(
    future: futureWelcome,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        return buildNewsList(snapshot.data!);
      } else {
        return Text('No data available');
      }
    },
  ),
),

    );
  }

  Future<Welcome> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=tesla&from=2024-09-11&sortBy=publishedAt&apiKey=cf17a39ef6034247963d9c7ab1aa9f49'));

    if (response.statusCode == 200) {
      // Decode the JSON response
      return Welcome.fromJson(jsonDecode(response.body));
    } else {
      // Handle error
      throw Exception('Failed to load news');
    }
  }

  Widget buildNewsList(Welcome data) {
    return ListView.builder(
      itemCount: data.articles.length,
      itemBuilder: (context, index) {
        final article = data.articles[index];
        return ListTile(
          title: Text(article.title),
          subtitle: Text(article.description ?? ''), // Handle null description
          trailing: Icon(Icons.arrow_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(url: article.url),
            ),
          ),
        );
      },
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final String url;

  const NewsDetailPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
      ),
     
    );
  }
}