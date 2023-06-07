import 'package:flutter/material.dart';
import 'package:frontend/appConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../components/bottom_bar.dart';
import 'all_pages.dart';

class AnnouncementDetail extends StatefulWidget {
  const AnnouncementDetail({super.key, required this.title, required this.id});

  final String title;
  final int id;

  @override
  State<AnnouncementDetail> createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  late Future news;

  Future getNews(int id) async {
    // var token = await storage.read(key: 'token');
    // print(token);
    var url = Uri.http(
        apiDomain, 'api/announcements/$id', {'populate': 'image'});
    print('url: $url');
    var response = await http.get(
      url,
      // headers: {
      //   'Authorization': 'Bearer $token',
      // },
    );
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print('jsonResponse: $jsonResponse');
      return jsonResponse;
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    news = getNews(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder(
          future: news,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var photoUrl = snapshot.data['data']['attributes']['image']
                  ['data']['attributes']['url'];
              return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.6,
                      // height: 270,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(
                                top: 9.0, left: 9.0, right: 9.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  snapshot.data['data']['attributes']['title'],
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                    snapshot.data['data']['attributes']['createdAt']
                                        .split('T')[0],
                                    style: const TextStyle(fontSize: 14))
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            // height: 86.0,
                            padding: const EdgeInsets.only(
                                top: 5.0, left: 9.0, right: 9.0, bottom: 12.0),
                            child: Text(
                              snapshot.data['data']['attributes']['content'],
                            ),
                          ),
                          Image.network("http://$apiDomain$photoUrl"),

                        ],
                      ),
                    ),
              ));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          }),
      bottomNavigationBar: const BottomBar(pageIndex: 0),
    );
  }
}
// class AnnouncementsCard extends StatelessWidget {
//   const AnnouncementsCard({
//     super.key,
//     required this.item,
//   });
//
//   final dynamic item;
//
//   @override
//   Widget build(BuildContext context) {
//     var photoUrl = item['attributes']['image']['data']['attributes']['url'];
//     return Card(
//       child: InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               PageRouteBuilder(
//                 pageBuilder: (context, __, ___) =>
//                 const AnnouncementPage(title: 'Announcement'),
//                 transitionDuration: const Duration(seconds: 0),
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(8),
//             child: SizedBox(
//               // width: MediaQuery.of(context).size.width * 0.6,
//               // height: 270,
//               child: Column(
//                 children: [
//                   Ink.image(
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: 130,
//                     image: NetworkImage(
//                         "http://$apiDomain$photoUrl"
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.topLeft,
//                     padding: const EdgeInsets.only(top:9.0, left: 9.0, right: 9.0),
//                     child: Text(item['attributes']['title'],
//                       style: const TextStyle(fontSize: 16),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.topLeft,
//                     // height: 86.0,
//                     padding: const EdgeInsets.only(top:5.0, left: 9.0, right: 9.0, bottom: 9.0),
//                     child: Text(item['attributes']['content'],
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 4,
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.topLeft,
//                     padding: const EdgeInsets.only(left: 9.0, right: 9.0),
//                     child: Text(
//                       item['attributes']['createdAt'].split('T')[0],
//                       style: const TextStyle(color: Colors.black54),
//                     ),
//                     // child: Text(id.toString(), style: const TextStyle(color: Colors.black54),),
//                   )
//                 ],
//               ),
//             ),
//           )
//
//       ),
//     );
//   }
// }
