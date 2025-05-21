class IaRecipe {
  final String title;
  final String description;
  final String image;
  final List<Ingredient> ingredients;
  final List<StepDetail> steps;
  final Map<String, String> nutrition;

  IaRecipe({
    required this.title,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.steps,
    required this.nutrition,
  });

  factory IaRecipe.fromJson(Map<String, dynamic> json) {
    return IaRecipe(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      ingredients: (json['ingredients'] as List)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      steps: (json['steps'] as List)
          .map((e) => StepDetail.fromJson(e))
          .toList(),
      nutrition: Map<String, String>.from(json['nutrition']),
    );
  }
}

class Ingredient {
  final String name;
  final String icon;
  final num amount;

  Ingredient({
    required this.name,
    required this.icon,
    required this.amount,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      icon: json['icon'],
      amount: json['amount'],
    );
  }
}

class StepDetail {
  final int no;
  final String description;
  final int timer;

  StepDetail({
    required this.no,
    required this.description,
    required this.timer,
  });

  factory StepDetail.fromJson(Map<String, dynamic> json) {
    return StepDetail(
      no: json['no'],
      description: json['description'],
      timer: json['timer'],
    );
  }
}
