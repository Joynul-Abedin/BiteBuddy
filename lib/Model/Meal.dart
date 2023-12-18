class Meal {
  final String strMeal;
  final String strMealThumb;
  final String idMeal;
  String? idCategory; // Add this field

  Meal({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
    required this.idCategory, // Add this field
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
      idMeal: json['idMeal'],
      idCategory: json['idCategory'], // Add this field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'strMeal': strMeal,
      'strMealThumb': strMealThumb,
      'idMeal': idMeal,
      'idCategory': idCategory, // Add this field
    };
  }
}
