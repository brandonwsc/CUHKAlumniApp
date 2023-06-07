import 'package:flutter/material.dart';
import '../components/bottom_bar.dart';
import 'all_pages.dart';

class PrivilegesPage extends StatefulWidget {
  const PrivilegesPage({super.key, required this.title});

  final String title;

  @override
  State<PrivilegesPage> createState() => _PrivilegesPage();
}

class _PrivilegesPage extends State<PrivilegesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text('University Libraries',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text('Alumni can apply for an Alumni Library Card for entering '
                  'all branch libraries under The Chinese University of Hong '
                  'Kong Library during opening hours.'),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text(
                  'CU Alumni Credit Card holders can enjoy HKD\$20 discount off the original price.'),
              Padding(padding: EdgeInsets.only(top: 12)),
              Text('Digital Library Service',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text('Alumni who are holders of Alumni Library Card can apply'
                  ' for the Digital Library Service for Alumni to gain '
                  'online access to a number of databases, including over'
                  ' 7,000 academic journals and magazines in the related '
                  'fields.'),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text(
                'Fees',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text('• Annual subscription fee: \$400 (Subscribe before 30 '
                  'June 2023 to enjoy a discount fee at \$300)'),
              Text(
                  '• Holders of CU Alumni Credit Card can enjoy a 20% discount'),
              Padding(padding: EdgeInsets.only(top: 12)),
              Text('University Swimming Pool',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text('Alumni holding CU Alumni Credit Card / Alumni Swimming Card'
                  ' OR accompanied by CU staff, student or alumni holding CU '
                  'Alumni Credit Card can use the University swimming pool '
                  'during opening hours. Opening hours and admission fees can'
                  ' be found here.'),
              Padding(padding: EdgeInsets.only(top: 12)),
              Text('Other University Sports Facilities',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text(
                  'Alumni holding CU Alumni Credit Card can use the following University Sports Facilities:'),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text(
                'University Sports Centre',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text('Badminton court, small basketball court and tennis courts'),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text(
                'Haddon Cave Sports Field',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text('Mini-soccer pitch and running track'),
              Padding(padding: EdgeInsets.only(top: 12)),
              Text('University Staff Common Room (SCR) Clubhouse',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text('The Staff Common Room Clubhouse was closed with effect from 1 February 2019.'),
              Padding(padding: EdgeInsets.only(top: 12)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(pageIndex: 0),
    );
  }
}
