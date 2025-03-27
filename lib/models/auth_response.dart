
import 'dart:convert';

import 'package:myapp/models/user.dart';

AuthResponse authResponseFromJson(String str) => AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
    AuthResponse({
        required this.status,
        this.user,
        this.accessToken,
        this.message
    });

    bool status;
    User? user;
    String? accessToken;
    String? message;

    factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        status: (json["user"] != null ) ? json["status"] : false,
        user: (json["user"] != null ) ? User.fromJson(json["user"] ) : null ,
        accessToken: json["accessToken"] ,
        message: json["message"] ,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "user": user?.toJson(),
        "accessToken": accessToken,
        "message": message,
    };
}
