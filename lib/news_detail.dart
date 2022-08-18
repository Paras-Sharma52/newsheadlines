import 'package:flutter/material.dart';

class Newsdetail extends StatelessWidget {
  final artical;
  Newsdetail({Key? key, required this.artical}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    String date = artical['publishedAt'];

    date.substring(11, 20);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Hero(
              tag: artical['urlToImage'],
              child: Image.network(
                artical['urlToImage'],
                // 'https://images.unsplash.com/photo-1657299143549-73fb118d68aa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60',
                height: size.height,
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: Color.fromARGB(207, 158, 158, 158)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 0, 64),
                  child: Text(
                    artical['title'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'RobotoSlab',
                        fontSize: 29),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        artical['source']['name'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'RobotoSlab-Regular',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Text(
                        date.substring(0, 10),
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'RobotoSlab-Regular',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
                // description
                Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 0, 10),
                      child: Text(
                        artical['description'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'RobotoSlab-Regular',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
