import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsheadlines/news_detail.dart';

class Headlinecard extends StatefulWidget {
  Headlinecard({Key? key}) : super(key: key);

  @override
  State<Headlinecard> createState() => _HeadlinecardState();
}

class _HeadlinecardState extends State<Headlinecard> {
  Future<void> fetchealine() async {
    final url = Uri.parse(
      "https://newsapi.org/v2/everything?q=Apple&from=2022-08-18&sortBy=popularity&apiKey=0c2508c5f1bc4e9097dbb77b359b777e",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final articles = json.decode(response.body) as Map<String, dynamic>;
        var resBody = articles['articles'];
        print(resBody);
        return resBody;
      }
    } catch (e) {
      return print('noresponce');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchealine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: fetchealine(),
        builder: ((context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Something Went Wrong Please?'),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () async {
                    fetchealine();
                  },
                ),
              ),
            );
          }
          final newsArti = snapshot.data;

          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : RefreshIndicator(
                  onRefresh: () async {
                    await fetchealine();
                  },
                  child: ListView.builder(
                      itemCount: 50,
                      itemBuilder: ((context, index) {
                        final articalSpec = newsArti[index];
                        String date = articalSpec['publishedAt'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => Newsdetail(
                                      artical: articalSpec,
                                    )),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: size.height / 3 - 50,
                            width: size.width,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Stack(
                                children: [
                                  Hero(
                                    tag: articalSpec['urlToImage'],
                                    child: Image.network(
                                      articalSpec['urlToImage'],
                                      // 'https://images.unsplash.com/photo-1657299143549-73fb118d68aa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60',
                                      height: size.height,
                                      width: size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          articalSpec['title'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'RobotoSlab',
                                              fontSize: 20),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 24, 0, 12),
                                            child: Text(
                                              articalSpec['source']['name'],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      'RobotoSlab-Regular',
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 24, 0, 12),
                                            child: Text(
                                              date.substring(0, 10),
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily:
                                                      'RobotoSlab-Regular',
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                );
        }));
  }
}
