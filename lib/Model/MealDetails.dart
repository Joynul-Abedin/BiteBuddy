class MealDetails {
  final String idMeal;
  final String strMeal;
  final String? strDrinkAlternate;
  String idCategory;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String? strTags;
  final String? strYoutube;
  final String? strSource;
  final List<String?> ingredients;
  final List<String?> measures;

  MealDetails({
    required this.idMeal,
    required this.strMeal,
    this.strDrinkAlternate,
    required this.idCategory,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    this.strTags,
    this.strYoutube,
    this.strSource,
    required this.ingredients,
    required this.measures,
  });

  factory MealDetails.fromJson(Map<String, dynamic> json) {
    List<String?> ingredients = [];
    List<String?> measures = [];

    for (int i = 1; i <= 20; i++) {
      ingredients.add(json['strIngredient$i']);
      measures.add(json['strMeasure$i']);
    }

    return MealDetails(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strDrinkAlternate: json['strDrinkAlternate'],
      strCategory: json['strCategory'],
      idCategory: json['idCategory'] ?? "",
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strTags: json['strTags'],
      strYoutube: json['strYoutube'],
      strSource: json['strSource'],
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strDrinkAlternate': strDrinkAlternate,
      'strCategory': strCategory,
      'idCategory': idCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
      'strSource': strSource,
      'strIngredient1': ingredients[0],
      'strIngredient2': ingredients[1],
      'strIngredient3': ingredients[2],
      'strIngredient4': ingredients[3],
      'strIngredient5': ingredients[4],
      'strIngredient6': ingredients[5],
      'strIngredient7': ingredients[6],
      'strIngredient8': ingredients[7],
      'strIngredient9': ingredients[8],
      'strIngredient10': ingredients[9],
      'strIngredient11': ingredients[10],
      'strIngredient12': ingredients[11],
      'strIngredient13': ingredients[12],
      'strIngredient14': ingredients[13],
      'strIngredient15': ingredients[14],
      'strIngredient16': ingredients[15],
      'strIngredient17': ingredients[16],
      'strIngredient18': ingredients[17],
      'strIngredient19': ingredients[18],
      'strIngredient20': ingredients[19],
      'strMeasure1': measures[0],
      'strMeasure2': measures[1],
      'strMeasure3': measures[2],
      'strMeasure4': measures[3],
      'strMeasure5': measures[4],
      'strMeasure6': measures[5],
      'strMeasure7': measures[6],
      'strMeasure8': measures[7],
      'strMeasure9': measures[8],
      'strMeasure10': measures[9],
      'strMeasure11': measures[10],
      'strMeasure12': measures[11],
      'strMeasure13': measures[12],
      'strMeasure14': measures[13],
      'strMeasure15': measures[14],
      'strMeasure16': measures[15],
      'strMeasure17': measures[16],
      'strMeasure18': measures[17],
      'strMeasure19': measures[18],
      'strMeasure20': measures[19],
    };
  }
}
