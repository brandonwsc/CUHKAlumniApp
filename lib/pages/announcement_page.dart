import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../appConfig.dart';
import '../components/bottom_bar.dart';
import 'all_pages.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key, required this.title});

  final String title;

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  late Future newsList;

  Future getNews() async {
    // var token = await storage.read(key: 'token');
    // print(token);
    var url = Uri.http(apiDomain, 'api/announcements', {'populate':'*', 'sort':'id'});
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
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder(
        future: newsList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                  // scrollDirection: Axis.horizontal,
                  child: Column(
                    children: snapshot.data['data'].map<Widget>((item) => AnnouncementsCard(item: item)).toList(),
                  ));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          }
      ),
      bottomNavigationBar: const BottomBar(pageIndex: 0),
    );
  }
}
class AnnouncementsCard extends StatelessWidget {
  const AnnouncementsCard({
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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            // width: MediaQuery.of(context).size.width * 0.6,
            // height: 270,
            child: Column(
              children: [
                Image.network("http://$apiDomain$photoUrl"),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(top:9.0, left: 9.0, right: 9.0),
                  child: Text(item['attributes']['title'],
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  // height: 86.0,
                  padding: const EdgeInsets.only(top:5.0, left: 9.0, right: 9.0, bottom: 9.0),
                  child: Text(item['attributes']['content'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
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
        )

      ),
    );
  }
}

// class AnnouncementCard extends StatelessWidget {
//   const AnnouncementCard(
//       {super.key,
//       required this.announcementId,
//       required this.announcementTopic,
//       required this.announcer,
//       required this.announcementContent,
//       required this.createdAt});
//
//   final int announcementId;
//   final String announcementTopic;
//   final String announcer;
//   final String announcementContent;
//   final String createdAt;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         child: InkWell(
//             onTap: () {},
//             child: Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                     Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           announcementTopic,
//                           textAlign: TextAlign.start,
//                           style:
//                               const TextStyle(fontSize: 18, color: Colors.purple),
//                         )),
//                     Padding(
//                         padding: const EdgeInsets.only(top: 4),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text(
//                               announcer,
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.deepPurpleAccent.shade700),
//                             ),
//                             Text(createdAt, style: const TextStyle(fontSize: 12))
//                           ],
//                         )),
//                     Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(announcementContent,
//                                 style: const TextStyle(fontSize: 16)))),
//                   ]))));
//   }
// }
