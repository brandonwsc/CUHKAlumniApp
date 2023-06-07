import 'dart:convert' as convert;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/appConfig.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../components/bottom_bar.dart';
import 'all_pages.dart';

_launchURL(url) async {
    await launchUrl(url);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future userData;
  late Future newsList;

  // var newsList = [1, 2, 3];
  var imgList = [
    'assets/istockphoto-1322277517-612x612.jpg',
    'assets/20494859.jpg',
    'assets/image-search-1600-x-840-px-62c6dc4ff1eee-sej-1280x720.png'
  ];
  var collegeList = [
    ['assets/cc.svg.png', 'https://www.ccc.cuhk.edu.hk'],
    ['assets/na.svg.png', 'https://www.na.cuhk.edu.hk'],
    ['assets/uc.svg.png', 'https://www.uc.cuhk.edu.hk'],
    ['assets/shaw.svg.png', 'https://www.shaw.cuhk.edu.hk'],
    ['assets/ws.png', 'https://www.ws.cuhk.edu.hk'],
    ['assets/morningside.png', 'https://www.morningside.cuhk.edu.hk'],
    ['assets/wys.png', 'https://wys.cuhk.edu.hk'],
    ['assets/shho.png', 'https://www.shho.cuhk.edu.hk'],
    ['assets/cwchu.svg.png', 'http://www.cwchu.cuhk.edu.hk']
  ];

  Future getNews() async {
    // var token = await storage.read(key: 'token');
    // print(token);
    var url = Uri.http(
        apiDomain, 'api/announcements', {'populate': '*', 'sort': 'id'});
    // print('url: $url');
    var response = await http.get(
      url,
      // headers: {
      //   'Authorization': 'Bearer $token',
      // },
    );
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      // print('jsonResponse: $jsonResponse');
      return jsonResponse;
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
  }

  Widget news(list) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.map<Widget>((item) => NewsCard(item: item)).toList(),
        ));
  }

  @override
  void initState() {
    newsList = getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: newsList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data['data'].sublist(0, 3);
            return ListView(children: [
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                ),
                items: imgList
                    .map((item) => Container(
                            child: Center(
                          child: Ink.image(
                            fit: BoxFit.cover,
                            width: 1000,
                            image: AssetImage(item),
                          ),
                        )))
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 6,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        HomeCard(ctx: 'Announcement'),
                        HomeCard(ctx: 'Magazine'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        HomeCard(ctx: 'E-Newsletter'),
                        HomeCard(ctx: 'Privileges'),
                      ],
                    ),
                    Row(children: const <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                    news(list),
                    Row(children: const <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                    ]),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 80,
                        viewportFraction: 0.3,
                        autoPlay: true,
                      ),
                      items: collegeList
                          .map((item) =>
                              College(image: item[0], url: Uri.parse(item[1])))
                          .toList(),
                    ),
                    Row(children: const <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                    ]),
                  ],
                ),
              ),
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: const BottomBar(pageIndex: 0),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.ctx,
  });

  final String ctx;

  @override
  Widget build(BuildContext context) {
    void onCardTap() {
      switch (ctx) {
        case "Announcement":
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, __, ___) =>
                  const AnnouncementPage(title: 'Announcement'),
              transitionDuration: const Duration(seconds: 0),
            ),
          );
          break;
        case "Magazine":
          _launchURL(Uri.parse('https://alumni.cuhk.edu.hk/en/magazine'));
          break;
        case "E-Newsletter":
          _launchURL(Uri.parse('https://enews.alumni.cuhk.edu.hk'));
          break;
        case "Privileges":
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, __, ___) =>
                  const PrivilegesPage(title: 'Privileges'),
              transitionDuration: const Duration(seconds: 0),
            ),
          );
          break;
      }
    }

    return Card(
      child: InkWell(
        onTap: () {
          onCardTap();
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4401,
          height: 90,
          child: Center(child: Text(ctx)),
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.item,
  });

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    var photoUrl = item['attributes']['image']['data']['attributes']['url'];
    int id = item['id'];
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, __, ___) =>
                  AnnouncementDetail(title: 'Announcement', id: id),
              transitionDuration: const Duration(seconds: 0),
            ),
          );
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 220,
          child: Column(
            children: [
              Ink.image(
                fit: BoxFit.cover,
                width: double.infinity,
                height: 130,
                image: NetworkImage("http://$apiDomain$photoUrl"),
              ),
              Container(
                alignment: Alignment.topLeft,
                height: 72.0,
                padding: const EdgeInsets.all(9.0),
                child: Text(
                  item['attributes']['content'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 9.0, right: 9.0),
                child: Text(
                  item['attributes']['createdAt'].split('T')[0],
                  style: const TextStyle(color: Colors.black54),
                ),
                // child: Text(id.toString(), style: const TextStyle(color: Colors.black54),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class College extends StatelessWidget {
  const College({
    super.key,
    required this.image,
    required this.url,
  });

  final String image;
  final Uri url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _launchURL(url);
      },
      child: Ink.image(
        fit: BoxFit.contain,
        width: 75,
        height: 75,
        image: AssetImage(image),
      ),
    );
  }
}
