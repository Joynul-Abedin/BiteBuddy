class Store {
  final String id;
  final String name;
  final Address address;
  final Location location;
  final String owner; // Assuming owner ID is sufficient
  final Contact contact;
  final String description;
  final List<String> categories;
  final List<String> menu; // Assuming menu contains IDs of FoodItems
  final Hours hours;
  final List<Rating> ratings;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.owner,
    required this.contact,
    required this.description,
    required this.categories,
    required this.menu,
    required this.hours,
    required this.ratings,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'],
      name: json['name'],
      address: Address.fromJson(json['address']),
      location: Location.fromJson(json['location']),
      owner: json['owner'],
      contact: Contact.fromJson(json['contact']),
      description: json['description'],
      categories: List<String>.from(json['categories']),
      menu: List<String>.from(json['menu'].map((item) => item.toString())),
      hours: Hours.fromJson(json['hours']),
      ratings: List<Rating>.from(
          json['ratings'].map((item) => Rating.fromJson(item))),
      images: List<String>.from(json['images']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }
}

class Contact {
  final String phone;
  final String email;
  final String website;

  Contact({
    required this.phone,
    required this.email,
    required this.website,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
      email: json['email'],
      website: json['website'] ?? '',
    );
  }
}

class Hours {
  final Map<String, OpenClose> dayHours;

  Hours({required this.dayHours});

  factory Hours.fromJson(Map<String, dynamic> json) {
    Map<String, OpenClose> hours = {};
    json.forEach((key, value) {
      hours[key] = OpenClose.fromJson(value);
    });
    return Hours(dayHours: hours);
  }
}

class OpenClose {
  final String open;
  final String close;

  OpenClose({required this.open, required this.close});

  factory OpenClose.fromJson(Map<String, dynamic> json) {
    return OpenClose(
      open: json['open'],
      close: json['close'],
    );
  }
}

class Rating {
  final double rating;
  final String user; // Assuming the user ID is sufficient
  final String review;
  final DateTime date;

  Rating({
    required this.rating,
    required this.user,
    required this.review,
    required this.date,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json['rating'].toDouble(),
      user: json['user'],
      review: json['review'],
      date: DateTime.parse(json['date']),
    );
  }
}
