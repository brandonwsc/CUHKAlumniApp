import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../appConfig.dart';
import '../components/bottom_bar.dart';
import '../components/input_field.dart';
import '../components/dropdown.dart';
import '../components/faculty.dart';
import '../components/label.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.title});

  final String title;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _gradYearController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  late String _collegeItemController = 'Chung Chi College';
  late String _facultyItemController = 'Arts';
  final storage = const FlutterSecureStorage();
  bool showLoginFailed = false;

  // bool _isLoading = false;

  void register(List<Object> arguments) async {
    var url = Uri.http(apiDomain, 'api/users');
    print(arguments);
    var response = await http.post(url, body: {
      'username': arguments[0],
      'firstName': arguments[1],
      'lastName': arguments[2],
      'email': arguments[3],
      'password': arguments[4],
      'graduationYear': arguments[5],
      'degree': arguments[6],
      'college': arguments[7],
      'faculty': arguments[8]
    });
    // var url = Uri.http(apiDomain, 'api/announcements', {'populate':'*', 'sort':'id'});
    // var response = await http.get(url);
    print(response.statusCode);
    // redirectToAuthPage();
    if (response.statusCode == 201) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      print(jsonResponse['id']);
      await storage.write(
          key: 'userId', value: jsonResponse['id'].toString());
      // userData = jsonResponse['user'];
      // var value = await storage.read(key: 'token');
      // print('value $value');
      redirectToAuthPage();
    }
  }

  void redirectToHomePage() {
    Navigator.pushNamed(context, "/home");
  }

  void redirectToAuthPage() {
    Navigator.pushNamed(context, "/auth");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
          )),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
            children: [
              Column(children: [
                const Label(title: 'Username'),
                InputField(
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
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
                const SizedBox(
                  height: 14,
                ),
                const Label(title: 'Email'),
                InputField(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(
                  height: 14,
                ),
                const Label(title: 'Password'),
                InputField(
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                const SizedBox(
                  height: 14,
                ),
                const Label(title: 'College'),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: DropdownButtonExample(
                    onItemChange: (newCollegeItem) {
                      _collegeItemController = newCollegeItem;
                      print('newCollegeItem: $newCollegeItem');
                    },
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const Label(title: 'Faculty'),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FacultyDropdown(
                    onItemChange: (newCollegeItem) {
                      _facultyItemController = newCollegeItem;
                      print('newCollegeItem: $newCollegeItem');
                    },
                  ),
                ),
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
                      _usernameController.text,
                      _firstNameController.text,
                      _lastNameController.text,
                      _emailController.text,
                      _passwordController.text,
                      _gradYearController.text,
                      _degreeController.text,
                      _collegeItemController,
                      _facultyItemController
                    ];
                    // print('data = $data');
                    register(data);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: const Text('Register'),
                ),
                const SizedBox(
                  height: 10,
                ),
                showLoginFailed
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border.all(
                              color: Colors.purple.shade100,
                              width: 1,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14))),
                        child: const Text(
                          'Please enter the correct email and password',
                          style: TextStyle(fontSize: 10, color: Colors.purple),
                        ),
                      )
                    : Container(),
              ]),
            ],
          ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(pageIndex: 3),
    );
  }
}


