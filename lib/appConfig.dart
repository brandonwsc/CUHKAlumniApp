import 'dart:io' show Platform;

String serverIp=Platform.isAndroid?"10.0.2.2":"127.0.0.1";
String apiDomain='$serverIp:1337';