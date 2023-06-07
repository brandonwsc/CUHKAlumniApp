import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../appConfig.dart';
import '../components/bottom_bar.dart';
import '../components/input_field.dart';
import '../service/notificationService.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final storage = const FlutterSecureStorage();
  bool showLoginFailed = false;

  // bool _isLoading = false;

  void login(List<String> arguments) async {
    var url = Uri.http(apiDomain, 'api/auth/local');
    var response = await http.post(url,
        body: {'identifier': arguments[0], 'password': arguments[1]});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      await storage.write(key: 'token', value: jsonResponse['jwt']);
      print(jsonResponse);
      print(jsonResponse['user']['id']);
      await storage.write(
          key: 'userId', value: jsonResponse['user']['id'].toString());
      // userData = jsonResponse['user'];
      // var value = await storage.read(key: 'token');
      // print('value $value');
      uploadFCMToken();
      redirectToHomePage();
    } else {
      setState(() {
        showLoginFailed = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          showLoginFailed = false;
        });
      });
    }
  }

  void redirectToHomePage() {
    Navigator.pushNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(context, "/home");
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(widget.title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
              )),
          body: SafeArea(
            child: Container(
              padding: MediaQuery.of(context).size.width > 600
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3)
                  : const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  SizedBox(
                    height: 235,
                    child: Column(children: [
                      InputField(
                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InputField(
                        hintText: 'Enter your password',
                        textInputType: TextInputType.text,
                        textEditingController: _passwordController,
                        isPass: true,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          var data = [
                            _emailController.text,
                            _passwordController.text
                          ];
                          // print('data = $data');
                          login(data);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: const Text('Login'),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14))),
                              child: const Text(
                                'Please enter the correct email and password',
                                style: TextStyle(fontSize: 10,color: Colors.purple),
                              ),
                            )
                          : Container(),
                    ]),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            ' Do not have an account?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BottomBar(pageIndex: 3),
        ));
  }
}
