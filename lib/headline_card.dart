import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsheadlines/news_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Headlinecard extends StatefulWidget {
  Headlinecard({Key? key}) : super(key: key);

  @override
  State<Headlinecard> createState() => _HeadlinecardState();
}

class _HeadlinecardState extends State<Headlinecard> {
  var waiting = false;
  var noConnection = false;
  Future<void> fetchealine() async {
    final url = Uri.parse(
      "https://newsapi.org/v2/everything?q=Apple&from=2022-09-21&sortBy=popularity&apiKey=d36156747a7d4d268e9d84d43886c735",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final articles = json.decode(response.body) as Map<String, dynamic>;
        var user = jsonEncode(articles);
        preferences.setString('news', user);
        info();
        setState(() {
          waiting = true;
          print(waiting);
        });
      }
    } catch (e) {
      setState(() {
        noConnection = true;
      });
      return print('noresponce');
    }
  }

  Future<void> info() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      Map userarticles =
          await jsonDecode(preferences.getString('news').toString());

      var resBody = await userarticles['articles'];

      // print(userarticles['articles']);
      return resBody;
    } catch (e) {
      print('data not available');
    }
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   waiting = true;
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    // TODO: implement initState
    fetchealine();
    info();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return waiting || noConnection
        ? FutureBuilder(
            future: info(),
            builder: ((context, AsyncSnapshot<dynamic> snapshot) {
              final newsArti = snapshot.data;

              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await info();
                      },
                      child: snapshot.data == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'No Data',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        snapshot.data == null
                                            ? fetchealine()
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                color: Colors.white,
                                              ));
                                      });
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: 35,
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
                                    height: size.height / 3 - 40,
                                    width: size.width,
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Stack(
                                        children: [
                                          Hero(
                                            tag: articalSpec['urlToImage'],
                                            child: Image.network(
                                              articalSpec['urlToImage'],
                                              height: size.height,
                                              width: size.width,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Text(
                                                    articalSpec['title'],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'RobotoSlab',
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10, 24, 0, 12),
                                                    child: Text(
                                                      articalSpec['source']
                                                          ['name'],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'RobotoSlab-Regular',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10, 24, 0, 12),
                                                    child: Text(
                                                      date.substring(0, 10),
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'RobotoSlab-Regular',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.normal,
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
            }))
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ));
  }
}
