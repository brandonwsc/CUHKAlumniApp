import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../appConfig.dart';
import '../components/bottom_bar.dart';
import '../components/input_field.dart';

class Auth extends StatefulWidget {
  const Auth({super.key, required this.title});

  final String title;

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final TextEditingController _authCodeController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool showAlert = false;
  // bool _isLoading = false;

  void confirm(List<String> arguments) async {
    var userId = await storage.read(key: 'userId');
    var url = Uri.http(apiDomain, 'api/user/confirm');
    var response =
        await http.post(url, body: {'id': userId, 'code': arguments[0]});
    // redirectToSuccess(); //tmp for demo
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      print(jsonResponse['code']);
      if (jsonResponse['code'] == 200) {
        redirectToSuccess();
      } else {
        showAlert = true;
      }
      // redirectToLogin();
    }
  }

  void redirectToLogin() {
    Navigator.pushNamed(context, "/login");
  }

  void redirectToSuccess() {
    Navigator.pushNamed(context, "/success");
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
                  const SizedBox(
                    height: 254,
                  ),
                  SizedBox(
                    height: 135,
                    child: Column(children: [
                      InputField(
                        hintText: 'Enter the 6-digit code',
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _authCodeController,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          var data = [_authCodeController.text];
                          // print('data = $data');
                          confirm(data);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: const Text('Verify'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      showAlert ? AlertDialog(
                        title: const Text('Verification Failed'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text('Please try again'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Resend Code'),
                            onPressed: () {
                              // Navigator.of(context).pop();
                              showAlert = false;
                            },
                          ),
                        ],
                      ) : Container(),
                    ]),
                  ),
                  ],
              ),
            ),
          ),
          bottomNavigationBar: const BottomBar(pageIndex: 3),
        ));
  }
}
