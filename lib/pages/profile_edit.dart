import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../appConfig.dart';
import '../service/loginService.dart';
import '../components/bottom_bar.dart';
import '../components/input_field.dart';
import '../components/dropdown.dart';
import '../components/label.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.title});

  final String title;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _gradYearController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late Future userData;
  final storage = const FlutterSecureStorage();
  bool showLoginFailed = false;

  void update(List<Object> arguments) async {
    var userId = await storage.read(key: 'userId');
    var token = await storage.read(key: 'token');
    var url = Uri.http(apiDomain, 'api/users/$userId');
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'description': arguments[0],
      'firstName': arguments[1],
      'lastName': arguments[2],
      // 'password': arguments[4],
      'graduationYear': arguments[3],
      'degree': arguments[4],
      // 'college': arguments[7],
    });
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      print(jsonResponse['id']);
      await storage.write(key: 'userId', value: jsonResponse['id'].toString());
    }
  }

  void redirectToHomePage() {
    Navigator.pushNamed(context, "/home");
  }

  @override
  void initState() {
    userData = getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, "/profile");
            },
          )),
      body: FutureBuilder(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data['description'] != null
                  ? _descriptionController.text = snapshot.data['description']
                  : _descriptionController.text = '';
              snapshot.data['firstName'] != null
                  ? _firstNameController.text = snapshot.data['firstName']
                  : _firstNameController.text = '';
              snapshot.data['lastName'] != null
                  ? _lastNameController.text = snapshot.data['lastName']
                  : _lastNameController.text = '';
              snapshot.data['graduationYear'] != null
                  ? _gradYearController.text =
                      snapshot.data['graduationYear'].toString()
                  : _gradYearController.text = '';
              snapshot.data['degree'] != null
                  ? _degreeController.text = snapshot.data['degree']
                  : _degreeController.text = '';
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Column(children: [
                          const Label(title: 'Description'),
                          InputField(
                            hintText: 'Describe yourself',
                            textInputType: TextInputType.text,
                            textEditingController: _descriptionController,
                            max: 10,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          const Label(title: 'First Name'),
                          InputField(
                            hintText: 'Enter your first name',
                            textInputType: TextInputType.text,
                            textEditingController: _firstNameController,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          const Label(title: 'Last Name'),
                          InputField(
                            hintText: 'Enter your last name',
                            textInputType: TextInputType.text,
                            textEditingController: _lastNameController,
                          ),
                          // const SizedBox(
                          //   height: 14,
                          // ),
                          // const Label(title: 'College'),
                          // Align(
                          //   alignment: AlignmentDirectional.centerStart,
                          //   child: DropdownButtonExample(
                          //     onItemChange: (newCollegeItem) {
                          //       _collegeItemController = newCollegeItem;
                          //       print('newCollegeItem: $newCollegeItem');
                          //     },
                          //   ),
                          // ),
                          const SizedBox(
                            height: 14,
                          ),
                          const Label(title: 'Graduation Year'),
                          InputField(
                            hintText: 'Graduation Year',
                            textInputType: TextInputType.text,
                            textEditingController: _gradYearController,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          const Label(title: 'Degree'),
                          InputField(
                            hintText: 'e.g. BEng in IERG',
                            textInputType: TextInputType.text,
                            textEditingController: _degreeController,
                          ),
                          const SizedBox(
                            height: 14,
                          ),

                          OutlinedButton(
                            onPressed: () {
                              var data = [
                                _descriptionController.text,
                                _firstNameController.text,
                                _lastNameController.text,
                                _gradYearController.text,
                                _degreeController.text,
                                // _collegeItemController,
                              ];
                              // print('data = $data');
                              update(data);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            child: const Text('Done'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              return const Text('No post yet');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }),
      bottomNavigationBar: const BottomBar(pageIndex: 3),
    );
  }
}
