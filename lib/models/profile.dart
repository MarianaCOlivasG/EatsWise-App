class Profile {
  String name;
  String? picture;
  String idCustomer;
  bool isCompleted;

  Profile({
    required this.name,
    this.picture,
    required this.idCustomer,
    required this.isCompleted,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        name: json["name"],
        picture: json["picture"],
        idCustomer: json["id_customer"],
        isCompleted: json["is_completed"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "picture": picture,
        "id_customer": idCustomer,
        "is_completed": isCompleted
      };

  Profile copyWith({
    String? name,
    String? picture,
    String? idCustomer,
    bool? isCompleted,
  }) {
    return Profile(
      name: name ?? this.name,
      picture: picture ?? this.picture,
      idCustomer: idCustomer ?? this.idCustomer,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
