
import 'package:myapp/models/profile.dart';

class User {
    String uid;
    String? username;
    bool isOnline;
    dynamic picture;
    Profile? profile;

    User({
        required this.uid,
        this.username,
        required this.isOnline,
        required this.picture,
        this.profile,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        username: (json["username"] != null ) ?  json["username"] : null ,
        isOnline: json["is_online"],
        picture: (json["picture"] != null ) ?  json["picture"] : null,
        profile: (json["profile"] != null ) ?  Profile.fromJson(json["profile"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "is_online": isOnline,
        "picture": picture,
        "profile": profile?.toJson(),
    };
}