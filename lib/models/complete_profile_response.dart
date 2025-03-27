
import 'dart:convert';

CompleteProfileResponse completeProfileResponseFromJson(String str) => CompleteProfileResponse.fromJson(json.decode(str));

String completeProfileResponseToJson(CompleteProfileResponse data) => json.encode(data.toJson());

class CompleteProfileResponse {
    CompleteProfileResponse({
        required this.status,
        required this.message
    });

    bool status;
    String message;

    factory CompleteProfileResponse.fromJson(Map<String, dynamic> json) => CompleteProfileResponse(
        status: json["status"],
        message: json["message"] ,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
