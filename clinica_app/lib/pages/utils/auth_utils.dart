import 'dart:convert';

String basicAuthHeader(String username, String password) {
  //recibimos las credenciales
  String credentials = '$username:$password';
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  return 'Basic ${stringToBase64.encode(credentials)}';
}
